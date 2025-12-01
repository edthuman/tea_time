import SwiftUI

struct Settings: View {
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Settings").foregroundStyle(Color.black)
            Button {
                isShowingImagePicker.toggle()
            } label: {
                Text("Upload Jumpscare")
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(
                    isVisible: $isShowingImagePicker,
                    selectedImage: $inputImage,
                )
            }
            if (inputImage != nil) {
                Image(uiImage: inputImage!).resizable().scaledToFit()
                    .frame(height: 300)
            }
        }
        .padding(.bottom, 50)
        .frame(height: 730)
    }
}
