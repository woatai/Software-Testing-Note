param(
    [Parameter(Mandatory = $true)]
    [string]$AudioPath,

    [string]$Model = "small",

    [switch]$KeepWav
)

$ErrorActionPreference = "Stop"

$Python = "C:\Users\atai\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if (-not (Test-Path $Python)) {
    throw "未找到 Python：$Python"
}

$ResolvedAudio = (Resolve-Path -LiteralPath $AudioPath).Path
$AudioItem = Get-Item -LiteralPath $ResolvedAudio
$BasePath = Join-Path $AudioItem.DirectoryName $AudioItem.BaseName
$WavPath = "$BasePath.16k.wav"
$SimpleTextPath = "$BasePath.转写.简体.txt"

$Code = @"
from pathlib import Path
import subprocess
import imageio_ffmpeg
from opencc import OpenCC
from pywhispercpp.model import Model

audio = Path(r'''$ResolvedAudio''')
wav = Path(r'''$WavPath''')
simple_out = Path(r'''$SimpleTextPath''')
model_name = r'''$Model'''

ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
subprocess.run([
    ffmpeg, "-y", "-i", str(audio), "-ac", "1", "-ar", "16000", str(wav)
], check=True)

model = Model(model_name, n_threads=6, redirect_whispercpp_logs_to=None)
segments = model.transcribe(str(wav), language="zh", print_progress=False, print_realtime=False)

def ts(t):
    seconds = int(round(t / 100.0))
    h = seconds // 3600
    m = (seconds % 3600) // 60
    s = seconds % 60
    return f"{h:02d}:{m:02d}:{s:02d}"

lines = [f"音频文件：{audio.name}", f"转写模型：whisper.cpp {model_name}", ""]
for seg in segments:
    text = (seg.text or "").strip()
    if text:
        lines.append(f"[{ts(seg.t0)} - {ts(seg.t1)}] {text}")

raw_text = "\n".join(lines)
simple_out.write_text(OpenCC("t2s").convert(raw_text), encoding="utf-8")

print(str(simple_out))
"@

$Code | & $Python -

if (-not $KeepWav -and (Test-Path -LiteralPath $WavPath)) {
    Remove-Item -LiteralPath $WavPath
}

Write-Host "转写完成：$SimpleTextPath"
