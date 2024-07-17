{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices
, installShellFiles, gitignoreSource }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.40-sunscreen";

  # Source is local 
  src = gitignoreSource ./.;

  cargoHash = "sha256-v1EK+j79xuqLxwEsCNESnuaIer445/70IUApu4tE0KI=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd mdbook \
        --bash <($out/bin/mdbook completions bash) \
        --fish <($out/bin/mdbook completions fish) \
        --zsh  <($out/bin/mdbook completions zsh )
    '';

  passthru = { tests = { inherit nix; }; };

  meta = with lib; {
    description = "Create books from MarkDown";
    mainProgram = "mdbook";
    homepage = "https://github.com/sunscreen-tech/mdBook";
    changelog =
      "https://github.com/sunscreen-tech/mdBook/blob/v${version}/CHANGELOG.md";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ ryanorendorff ];
  };
}
