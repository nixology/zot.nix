{ inputs, ... }:
let
  nixology = inputs.self.components.nixology // inputs.flake.components.nixology;

  implementation = {
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

  check = {
    perSystem =
      { pkgs, ... }:
      let
        evalZot = inputs.flake.lib.evalComponent { inherit inputs; } nixology.zot.zot;
      in
      {
        checks.zot-component = pkgs.runCommandLocal "zot-component-check" { } ''
          : ${builtins.seq evalZot.config "ok"}
          touch "$out"
        '';
      };
  };
in
{
  imports = [
    check
    implementation
  ];

  flake.components = {
    nixology.zot.zot = {
      inherit implementation;

      dependencies = [
        nixology.core.perSystem
      ];

      meta = {
        description = "Zot is a production-ready, OCI-native container image and artifact registry. It includes the zot server, the zli CLI tool, and the zui web UI extension.";
        shortDescription = "OCI-native container image and artifact registry";
      };
    };
  };
}
