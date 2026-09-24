# Curated marketplace extensions not available from nixpkgs.
{ pkgs, ... }:
let
  vscode-utils = pkgs.vscode-utils;
in
{
  "ms-vscode"."remote-explorer" = vscode-utils.extensionFromVscodeMarketplace {
    name = "remote-explorer";
    publisher = "ms-vscode";
    version = "0.5.2024081309";
    sha256 = "0ywbs6zrbzcmwxnwkkj2dzakbaxmdz2sf6ps6ms9mvd8iksmyk30";
  };
  "cschlosser"."doxdocgen" = vscode-utils.extensionFromVscodeMarketplace {
    name = "doxdocgen";
    publisher = "cschlosser";
    version = "1.4.0";
    sha256 = "1d95znf2vsdzv9jqiigh9zm62dp4m9jz3qcfaxn0n0pvalbiyw92";
  };
  "kevinrose"."vsc-python-indent" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vsc-python-indent";
    publisher = "kevinrose";
    version = "1.18.0";
    sha256 = "1z8ydwz43znccrhpms0v34236nx4nic65mpfd9ka3w4ng1q8q8w6";
  };
  "donjayamanne"."python-extension-pack" = vscode-utils.extensionFromVscodeMarketplace {
    name = "python-extension-pack";
    publisher = "donjayamanne";
    version = "1.7.0";
    sha256 = "1rvhhmbl8dn1klni3hj57fbybnsli88hip6jfncd9k0mfgmb00vv";
  };
  "wayou"."vscode-todo-highlight" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-todo-highlight";
    publisher = "wayou";
    version = "1.0.5";
    sha256 = "1sg4zbr1jgj9adsj3rik5flcn6cbr4k2pzxi446rfzbzvcqns189";
  };
  "formulahendry"."auto-complete-tag" = vscode-utils.extensionFromVscodeMarketplace {
    name = "auto-complete-tag";
    publisher = "formulahendry";
    version = "0.1.0";
    sha256 = "14xmglw17wlzsil9dpbnn96kvzavfds6xmyf4s9crxydm1swpgsz";
  };
  "mohsen1"."prettify-json" = vscode-utils.extensionFromVscodeMarketplace {
    name = "prettify-json";
    publisher = "mohsen1";
    version = "0.0.3";
    sha256 = "1spj01dpfggfchwly3iyfm2ak618q2wqd90qx5ndvkj3a7x6rxwn";
  };
  "tamasfe"."even-better-toml" = vscode-utils.extensionFromVscodeMarketplace {
    name = "even-better-toml";
    publisher = "tamasfe";
    version = "0.19.2";
    sha256 = "0q9z98i446cc8bw1h1mvrddn3dnpnm2gwmzwv2s3fxdni2ggma14";
  };
  "pflannery"."vscode-versionlens" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-versionlens";
    publisher = "pflannery";
    version = "1.14.2";
    sha256 = "0r5f14bvdnxwwa20xbjy6ybbmjpxm1z41vgw0q9r6rlzwnsj3827";
  };
  "inferrinizzard"."prettier-sql-vscode" = vscode-utils.extensionFromVscodeMarketplace {
    name = "prettier-sql-vscode";
    publisher = "inferrinizzard";
    version = "1.6.0";
    sha256 = "1d4vf3gh2x4ycf8ppvvb5d6rsg2ayckd05rkp3w1kw5gxgzmzalp";
  };
  "janisdd"."vscode-edit-csv" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-edit-csv";
    publisher = "janisdd";
    version = "0.10.0";
    sha256 = "153k5vdzbhliyf7qfpv6xxsvja1liqpq5x82wcjjxcv9j096bizs";
  };
  "nhoizey"."gremlins" = vscode-utils.extensionFromVscodeMarketplace {
    name = "gremlins";
    publisher = "nhoizey";
    version = "0.26.0";
    sha256 = "1sfs98nxm5ylcjrmylr5y68ddml8cfg1q1wdm7wvhfhjqx4kig9h";
  };
  "searking"."preview-vscode" = vscode-utils.extensionFromVscodeMarketplace {
    name = "preview-vscode";
    publisher = "searking";
    version = "2.3.7";
    sha256 = "022ipz6izpvaflp2jcijj9xdpasx2sxjhlw7z8gbndd7kmvpd6xq";
  };
  "meganrogge"."template-string-converter" = vscode-utils.extensionFromVscodeMarketplace {
    name = "template-string-converter";
    publisher = "meganrogge";
    version = "0.6.1";
    sha256 = "168v08bpkw3wgy1x67z8vjsi5hrmmh16rj8kvkqd3zr63p76jjn3";
  };
  "bbenoist"."vagrant" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vagrant";
    publisher = "bbenoist";
    version = "0.5.0";
    sha256 = "1fkrv6ncw752n5ni7c3p9hd7l9f2msw7rgxw07x2wigp3zd5y06x";
  };
  "bruno-api-client"."bruno" = vscode-utils.extensionFromVscodeMarketplace {
    name = "bruno";
    publisher = "bruno-api-client";
    version = "3.1.0";
    sha256 = "0l46jafrf2mfii72gv4ikhygks1s29ys36p71517bdk2rjfj5d4c";
  };
  "amrmetwally"."vim-find-highlight" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vim-find-highlight";
    publisher = "amrmetwally";
    version = "0.0.11";
    sha256 = "sha256-wY49t7Midd/8L3RBJMzrVUtJCFpmcCtS9NkEP06SwTk=";
  };
  "amrmetwally"."rust-mod-opener" = vscode-utils.extensionFromVscodeMarketplace {
    name = "rust-mod-opener";
    publisher = "amrmetwally";
    version = "0.0.1";
    sha256 = "sha256-auY2MxmeUFaxPUgtTOlpowsygXUusmpBWFDa72um1+8=";
  };
  "amrmetwally"."add-arround" = vscode-utils.extensionFromVscodeMarketplace {
    name = "add-arround";
    publisher = "amrmetwally";
    version = "0.0.2";
    sha256 = "0ppiaj23y91waisidrm0pq5by1z0r6mgazcpiz16wfwld1c6x3gm";
  };
  "yy0931"."go-to-next-error" = vscode-utils.extensionFromVscodeMarketplace {
    name = "go-to-next-error";
    publisher = "yy0931";
    version = "1.0.7";
    sha256 = "sha256-LIa+ka5LWPLWCGVStdLxvmOzJvWBqW1kTa72rjuDTUg=";
  };
}
