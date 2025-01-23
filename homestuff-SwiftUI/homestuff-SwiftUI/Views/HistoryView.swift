import SwiftUI

struct HistoryPage: View {
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    HStack {
                        Spacer()
                        Text("Histori")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 36)
                            .padding(.bottom, 24)
                        Spacer()
                    }
                    .padding(.top, 48)
                    
                    .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(28)
                    
                    
                    List {
                        ForEach(0..<5, id: \.self) { _ in
                            ScrollView{
                                ItemRow()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}



struct HistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryPage()
    }
}
struct ItemRow: View {
    var body: some View {
        ZStack{
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Nama Barang")
                            .font(.headline)
                        Spacer()
                        Text("Selesai")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        
                    }
                    Divider().padding(.vertical, 4)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detail barang:")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Text("Masukkan dan kadaluarsa barang")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text("January 12, 2025")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Divider()
                            Text("February 14, 2025")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.all)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill( Color(red: 0.98, green: 0.94, blue: 0.94)))
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1))
            }
            .padding(.vertical, 8)
        }
    }
}
