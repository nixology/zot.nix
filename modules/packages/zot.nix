{ inputs, ... }:
let
  module = {
    perSystem =
      { pkgs, system, ... }:
      {
        packages.zot =
          let
            mergedSrc = pkgs.runCommand "zot-zui-merged-src" { } ''
              mkdir $out
              cp -R ${inputs.ZOT}/* $out
              chmod +w $out/pkg/extensions
              cp -R ${inputs.self.packages.${system}.zui}/* $out/pkg/extensions
            '';

            version = inputs.ZOT.shortRev;
          in
          pkgs.buildGoModule {
            pname = "zot";
            inherit version;
            src = mergedSrc;

            goSum = "${mergedSrc}/go.sum";

            subPackages = [
              "cmd/zot"
              "cmd/zli"
            ];

            env = {
              GOEXPERIMENT = "jsonv2";
            };

            ldflags = [
              "-X zotregistry.dev/zot/pkg/api/config.ReleaseTag=${version}"
              "-X zotregistry.dev/zot/pkg/api/config.Commit=${inputs.ZOT.rev}"
              "-X zotregistry.dev/zot/pkg/api/config.BinaryType=minimal"
              "-X zotregistry.dev/zot/pkg/api/config.GoVersion=${pkgs.go.version}"
              "-s"
              "-w"
            ];

            tags = [
              "containers_image_openpgp"
              "debug"
              "imagetrust"
              "lint"
              "metrics"
              "mgmt"
              "profile"
              "scrub"
              "search"
              "sync"
              "ui"
              "userprefs"
              "events"
            ];

            doCheck = false;

            vendorHash = "sha256-09LQKBKyqpgBbC44VPsZ3RJcwrHWy6TpF87u35UgcYI=";
          };
      };
  };

  component = {
    inherit module;
    dependencies = with inputs.parts.components; [
      nixology.parts.systems
    ];
  };
in
{
  imports = [ module ];
  flake.components = {
    nixology.zot.zot = component;
  };
}
