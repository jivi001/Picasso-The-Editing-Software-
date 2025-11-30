$ErrorActionPreference = "Stop"

# Path to the ephemeral CMakeLists.txt for media_kit_libs_windows_video
$TargetFile = "windows\flutter\ephemeral\.plugin_symlinks\media_kit_libs_windows_video\windows\CMakeLists.txt"

if (-not (Test-Path $TargetFile)) {
    Write-Warning "Target file not found: $TargetFile"
    Write-Warning "Make sure 'flutter pub get' has been run first."
    exit 0
}

Write-Host "Patching $TargetFile..."

$content = Get-Content $TargetFile -Raw

# Regex to find add_custom_command(TARGET ... COMMAND ...) without POST_BUILD/PRE_BUILD/PRE_LINK
# We look for add_custom_command, followed by TARGET, but NOT followed by POST_BUILD before COMMAND
# This is a bit complex with regex, so we'll use a simpler replacement strategy that works for this specific plugin's structure.

# The warning usually comes from lines like:
# add_custom_command(
#   TARGET ...
#   COMMAND ...
# )

# We will replace "TARGET ${target_name}" with "TARGET ${target_name} POST_BUILD"
# But we need to be careful not to double-add it.

if ($content -match "POST_BUILD") {
    Write-Host "File already appears to have POST_BUILD or similar. Skipping aggressive patching to avoid duplicates."
    # We might still want to check specific known missing locations if we knew them, 
    # but for now let's assume if it's missing, it's missing everywhere relevant.
}

# Specific patch for media_kit_libs_windows_video
# It usually looks like:
# add_custom_command(
#     TARGET ${plugin_name}_plugin
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different
#     ...
# )

# We'll do a regex replace to insert POST_BUILD after the TARGET line
$newContent = $content -replace '(\s+TARGET\s+\S+)(\s+COMMAND)', '$1 POST_BUILD$2'

if ($content -ne $newContent) {
    Set-Content -Path $TargetFile -Value $newContent
    Write-Host "Successfully patched CMakeLists.txt with POST_BUILD." -ForegroundColor Green
} else {
    Write-Host "No changes needed or pattern not found." -ForegroundColor Yellow
}
