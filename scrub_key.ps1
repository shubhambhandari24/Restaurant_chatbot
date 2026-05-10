$f = "src/main/java/com/ai/restaurant/service/GeminiService.java"
if (Test-Path $f) {
    $content = Get-Content $f -Raw
    $content = $content -replace "AIzaSyDh4vj1WkBDPeHoRwJXB5HJYXGUoAWmtXo", "REMOVED_SEE_GEMINI_PROPERTIES"
    Set-Content $f $content -NoNewline
}
