shared_examples "require_user_sign_in" do 
  it "reidirects to sign in path" do 
    expect(response).to redirect_to sign_in_path 
  end 
end 
