# Movies

## Run Instructions
1. Download the binary
2. `cd` into the downloaded location
3.  Run the command `./Movies <url>` or any variant found below.
4. Press enter to page through results

### Commands:
```
Movies -h                               Show the help menu.
Movies <url>                            Load movies from provided URL containing valid JSON.
Movies <url> [--sort=Title]             Load movies sorted alphabetically by title.
Movies <url> [--sort=Year]              Load movies sorted by newest to oldest release date.
Movies <url> [--sort=Runtime]           Load movies sorted shortest to longest.
Movies <url> [--sort=UploadDate]        Load movies sorted by upload date, newest to oldest.
Movies <url> <sort> -r                  Load movies using the provided sort in reverse order.
```

## Build Instructions
Disclaimer: You may need to have Xcode and Xcode developer tools installed to build this on your own. I already had it configured before doing this.
1. Clone the project
2. `cd` into the project directory
3. Run the command `swift build`
4. You can then run the same commands as above as in this example: `.build/debug/Movies <url>`

## Field Explanations
### Included Fields
* Title - Needed for users to identify the movie
* Year - Common information displayed with movies across other services
* Duration - Common information displayed with movies across other services
* Created At - Used as an upload date for users to know when the film was added to the list and allows sorting by new

### Omitted Fields
* ID - Irrelevant to end users. Used for internal data management
* Video Encoding - Advanced information that most users wouldn't understand
* Audio Encoding - Advanced information that most users wouldn't understand
* Bitdepth - Advanced information that most users wouldn't understand
* Aspect Ratio - Considered adding. Would have made more sense if it was a resolution instead. Most users won't know their aspect ratios.
* Audio Channels - Advanced information that most users wouldn't understand
* Framerate - Considered adding but decided most users wouldn't understand it.

## Additional Notes
* If I were to expand on the project, I would add an additional flag that returns the advanced information that was omitted.
* I added a flag for reverse sorting that I did not see required in the instructions but felt as if it made sense to have.
* I tried to use uncommon terminal colors for my text. The output colors are cyan, yellow, red, and magenta. If your background or regular text is the same color then you will need to change those colors temporarily to view optimal behavior from this application. 
