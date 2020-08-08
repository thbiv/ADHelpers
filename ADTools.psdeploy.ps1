Deploy ADTools {
    By PSGalleryModule {
        FromSource "$PSScriptRoot\_output\ADTools"
        To SFGallery
    }
}