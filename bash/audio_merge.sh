#!/bin/bash

seriesPath="./complete/series/Step.By.Step.S01-S07"
krokPath="./complete/krok za krokem cz"
targetPath="/srv/dev-disk-by-uuid-4ca1dab4-dabe-459f-9ced-bdb6f0d4fcb2/Backups/StepByStep"
logFile="mergelog.txt"

# Get all avi files recursively in the series directory
shopt -s globstar  # Enable recursive globbing
seriesFiles=( "$seriesPath"/**/*.avi )

for seriesFile in "${seriesFiles[@]}"; do
    # Extract the season and episode information from Step.By.Step filenames
    seasonEpisodeSeries=$(basename "$seriesFile" | sed -E 's/.*S([0-9]+)E([0-9]+).*/S\1E\2/i')

    # Construct the corresponding mkv file path based on Step.By.Step format
    krokFileSeries=$(find "$krokPath" -type f -iname "*$seasonEpisodeSeries*.mkv" -print -quit)

    if [ -n "$krokFileSeries" ]; then
        echo "Match found: $seriesFile and $krokFileSeries"
        # Your further actions or commands here
        outputPath="$targetPath/StepByStep_${seasonEpisodeSeries}_CZ_EN_HU.mkv"

        # Check if the output file already exists (case-insensitive)
        if [ ! -e "$outputPath" ]; then
            echo "Output file does not exist. Running mkvmerge..."
            mkvmerge --output "$outputPath" "$krokFileSeries" --no-video "$seriesFile" >> "$logFile"
        else
            existingFilename=$(basename "$outputPath")
            echo "Output file '$existingFilename' already exists. Skipping mkvmerge." >> "$logFile"
        fi
    else
        # If no match found in Step.By.Step format, try another format
        # Extract the season and episode information from Krok za krokem filenames
        seasonEpisodeKrok=$(basename "$seriesFile" | sed -E 's/.*S([0-9]+)E([0-9]+).*/S\1E\2/i')

        # Construct the corresponding mkv file path based on Krok za krokem format
        krokFileKrok=$(find "$krokPath" -type f -iname "*$seasonEpisodeKrok*.mkv" -print -quit)

        if [ -n "$krokFileKrok" ]; then
            echo "Match found: $seriesFile and $krokFileKrok"
            # Your further actions or commands here
            outputPath="$targetPath/StepByStep_${seasonEpisodeKrok}_CZ_EN_HU.mkv"

            # Check if the output file already exists (case-insensitive)
            if [ ! -e "$outputPath" ]; then
                echo "Output file does not exist. Running mkvmerge..."
                mkvmerge --output "$outputPath" "$krokFileKrok" --no-video "$seriesFile" >> "$logFile"
            else
                existingFilename=$(basename "$outputPath")
                echo "Output file '$existingFilename' already exists. Skipping mkvmerge." >> "$logFile"
            fi
        fi
    fi
done
