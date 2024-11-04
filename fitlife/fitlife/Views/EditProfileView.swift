import SwiftUI
import SwiftData
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var userGoals: UserGoals
    @State private var editedName: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var displayedImage: Image?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .center) {
                        if let displayedImage {
                            displayedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                )
                        } else if let profilePicture = userGoals.profilePicture,
                                  let uiImage = UIImage(data: profilePicture) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                )
                        }
                        
                        PhotosPicker(selection: $selectedItem,
                                   matching: .images) {
                            Text("Change Photo")
                                .foregroundStyle(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    
                    TextField("Name", text: $editedName)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        userGoals.name = editedName
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            editedName = userGoals.name
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    userGoals.profilePicture = data
                    if let uiImage = UIImage(data: data) {
                        displayedImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
} 