import SwiftUI
import SwiftData
import PhotosUI

struct EditProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var userGoals: UserGoals
    @State private var editedName: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var displayedImage: Image?
    
    private let maxNameLength = 30
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Profile Picture Section
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let displayedImage {
                                displayedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            } else if let profilePicture = userGoals.profilePicture,
                                      let uiImage = UIImage(data: profilePicture) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            
                            PhotosPicker(selection: $selectedItem,
                                       matching: .images) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.white)
                                    .background(Circle().fill(Color("GradientStart")))
                            }
                            .offset(x: 6, y: 6)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Name Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Name")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("Name", text: $editedName)
                            .textFieldStyle(.plain)
                            .font(.title3)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .onChange(of: editedName) { newValue in
                                if newValue.count > maxNameLength {
                                    editedName = String(newValue.prefix(maxNameLength))
                                }
                            }
                        
                        Text("\(editedName.count)/\(maxNameLength)")
                            .font(.caption)
                            .foregroundColor(editedName.count >= maxNameLength ? .red : .gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        userGoals.userProfile.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
                        dismiss()
                    }
                    .bold()
                    .foregroundColor(Color("GradientStart"))
                }
            }
        }
        .onAppear {
            editedName = userGoals.userProfile.name
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
