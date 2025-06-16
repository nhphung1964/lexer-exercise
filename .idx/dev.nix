# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    # pkgs.go
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.gnumake
    pkgs.jre_minimal
    pkgs.gh
    # pkgs.nodejs_20
    # pkgs.nodePackages.nodemon
  ];
  # Sets environment variables in the workspace
  env = {
    VENV_DIR = ".venv";
  };
  
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
    ];
    # Enable previews
    previews = {
      enable = true;
      previews = {
         web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
           command = ["bash" "-c" 
           ''
           source .venv/bin/activate 
           python -m http.server $PORT --directory .
           ''];
           manager = "web";
           env = {
        #     # Environment variables to set for your server
             PORT = "$PORT";
         };
         };
      };
    };
    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        create-venv = ''
          python -m venv $VENV_DIR

          if [ ! -f requirements.txt ]; then
            echo "antlr4-python3-runtime==4.13.2" > requirements.txt
            echo "pytest" >> requirements.txt
            echo "pytest-html" >> requirements.txt
            echo "pytest-timeout" >> requirements.txt
          fi

          source $VENV_DIR/bin/activate
          pip install -r requirements.txt
        '';
        default.openFiles = [  "README.md" ];
      };
      # Runs when the workspace is (re)started
      onStart = {
       check-venv-existence = ''
          if [ ! -d $VENV_DIR ]; then
            python -m venv $VENV_DIR
          fi

          if [ ! -f requirements.txt ]; then
            echo "antlr4-python3-runtime==4.13.2" > requirements.txt
            echo "pytest" >> requirements.txt
            echo "pytest-html" >> requirements.txt
            echo "pytest-timeout" >> requirements.txt
          fi

          source $VENV_DIR/bin/activate
          pip install -r requirements.txt
          
        '';
      };
    };
  };
}
