//
//  ReceiveSolanaView.swift
//  Solance
//
//  Created by Alexander Senin on 09.05.2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ReceiveSolanaView: View {
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color(0x99455FF), Color(0x14F195)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    @Binding var publicKey: String
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            if isShowing {
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isShowing = false } }
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(gradient)
                        .frame(width: 350, height: 350, alignment: .center)
                    Image(uiImage: (generateQR(publicKey) ?? UIImage(systemName: "xmark"))!)
                        .interpolation(.none)
                        .resizable()
                        .cornerRadius(8)
                        .frame(width: 300, height: 300, alignment: .center)
                    Image("solana")
                        .resizable()
                        .frame(width: 111, height: 111, alignment: .center)
                }.frame(height: 700)
                 .frame(maxWidth: .infinity)
                 .transition(.move(edge: .bottom))
            }
        }
    }
    
    private func generateQR(_ publicKey: String) -> UIImage? {
        let data = Data(publicKey.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return nil
    }
}

struct ReceiveSolanaView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveSolanaView(publicKey: .constant("12KDRYjm3LpZVz5Y9JoS81trgtZ2opW78NgyFm11pXMM"), isShowing: .constant(true))
            .preferredColorScheme(.dark)
    }
}
