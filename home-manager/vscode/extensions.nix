# Generated by https://github.com/nix-community/nix4vscode
{ pkgs, lib }:
let
  inherit (pkgs.stdenv)
    isDarwin
    isLinux
    isi686
    isx86_64
    isAarch32
    isAarch64
    ;
  vscode-utils = pkgs.vscode-utils;
  merge = lib.attrsets.recursiveUpdate;
in
merge
  (merge
    (merge
      (merge
        {
          "ms-python"."vscode-pylance" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-pylance";
            publisher = "ms-python";
            version = "2024.9.101";
            sha256 = "1cdfb7l6qfxshi162cb11103n46f7lly0rasl41sw7gjpfr19759";
          };
          "ms-toolsai"."jupyter-keymap" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jupyter-keymap";
            publisher = "ms-toolsai";
            version = "1.1.2";
            sha256 = "02rb4r5zspicj2c7ffrr6xj6dmk0948lnl2f8f89xlfrkh2z44pl";
          };
          "ms-toolsai"."jupyter-renderers" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jupyter-renderers";
            publisher = "ms-toolsai";
            version = "1.0.19";
            sha256 = "1cv1qr3cjwpnlpccg8dwcds96ycb8i0wy97b324inrjhcgfgg7fp";
          };
          "esbenp"."prettier-vscode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "11.0.0";
            sha256 = "1fcz8f4jgnf24kblf8m8nwgzd5pxs2gmrv235cpdgmqz38kf9n54";
          };
          "ms-toolsai"."vscode-jupyter-cell-tags" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-jupyter-cell-tags";
            publisher = "ms-toolsai";
            version = "0.1.9";
            sha256 = "1xm8l6wrfqird8pdw7gm2l604iqdwbc2cd2pri9l1nmbncaxpq2w";
          };
          "ms-toolsai"."vscode-jupyter-slideshow" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-jupyter-slideshow";
            publisher = "ms-toolsai";
            version = "0.1.6";
            sha256 = "1hqan5ax3dl1anl0fva4df79609r83d7g325rn0kwxqqnyp0qyvy";
          };
          "dbaeumer"."vscode-eslint" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-eslint";
            publisher = "dbaeumer";
            version = "3.0.13";
            sha256 = "0yjrylvkw5q9w7kjigndm5m66qn8nranrm0m7qna8ggi0f2nz5cp";
          };
          "twxs"."cmake" = vscode-utils.extensionFromVscodeMarketplace {
            name = "cmake";
            publisher = "twxs";
            version = "0.0.17";
            sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
          };
          "ms-azuretools"."vscode-docker" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-docker";
            publisher = "ms-azuretools";
            version = "1.29.3";
            sha256 = "1j35yr8f0bqzv6qryw0krbfigfna94b519gnfy46sr1licb6li6g";
          };
          "ms-vscode"."cmake-tools" = vscode-utils.extensionFromVscodeMarketplace {
            name = "cmake-tools";
            publisher = "ms-vscode";
            version = "1.20.10";
            sha256 = "09idk0kg6qhifrkj5zbhq6dkchv9dx07gv2v6rn32i1xl47p7k7w";
          };
          "eamodio"."gitlens" = vscode-utils.extensionFromVscodeMarketplace {
            name = "gitlens";
            publisher = "eamodio";
            version = "2024.9.2605";
            sha256 = "00zvx7p0yykm7qsnnkfjsi3iinxmsnc6c5xmsp8lx0bgal3gisvj";
          };
          "ms-vscode"."cpptools-themes" = vscode-utils.extensionFromVscodeMarketplace {
            name = "cpptools-themes";
            publisher = "ms-vscode";
            version = "2.0.0";
            sha256 = "05r7hfphhlns2i7zdplzrad2224vdkgzb0dbxg40nwiyq193jq31";
          };
          "ms-vscode"."cpptools-extension-pack" = vscode-utils.extensionFromVscodeMarketplace {
            name = "cpptools-extension-pack";
            publisher = "ms-vscode";
            version = "1.3.0";
            sha256 = "11fk26siccnfxhbb92z6r20mfbl9b3hhp5zsvpn2jmh24vn96x5c";
          };
          "ms-vscode-remote"."remote-containers" = vscode-utils.extensionFromVscodeMarketplace {
            name = "remote-containers";
            publisher = "ms-vscode-remote";
            version = "0.387.0";
            sha256 = "1ibqqpqn3jdx5f52p0478620d9v2wizvdrkdjr98hsk7qdpvryxg";
          };
          "pkief"."material-icon-theme" = vscode-utils.extensionFromVscodeMarketplace {
            name = "material-icon-theme";
            publisher = "pkief";
            version = "5.11.1";
            sha256 = "0f5nvs7z3zfdsqrl6pcczpbnzslf40npg792k1pv6xlrwy52s4ad";
          };
          "github"."vscode-pull-request-github" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-pull-request-github";
            publisher = "github";
            version = "0.97.2024092604";
            sha256 = "12h9k0dcgn5g7wm08929z4lqi4p54na1xdapl1vb7a584cx3h6nm";
          };
          "ms-python"."isort" = vscode-utils.extensionFromVscodeMarketplace {
            name = "isort";
            publisher = "ms-python";
            version = "2023.13.12321012";
            sha256 = "00i27f61yqq79yhvd52ffwdq0dz1lw2zwgkz7da58h0wvps0ib1h";
          };
          "ms-vscode-remote"."remote-ssh" = vscode-utils.extensionFromVscodeMarketplace {
            name = "remote-ssh";
            publisher = "ms-vscode-remote";
            version = "0.115.2024092415";
            sha256 = "0c329ngi004k0lp63xgv202a1qxvjh3kcanvf36fq7gp0drnpn6n";
          };
          "ecmel"."vscode-html-css" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-html-css";
            publisher = "ecmel";
            version = "2.0.10";
            sha256 = "0a2czl36nq32jp6bafda3a0x0awm2d3agkvcn9vn0hkp37n7lh3q";
          };
          "ms-vscode-remote"."remote-ssh-edit" = vscode-utils.extensionFromVscodeMarketplace {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.86.0";
            sha256 = "0cmh2d73y1kmp6a92h3z7gams7lnqvb7rgib52kqslm4hyhdmii6";
          };
          "formulahendry"."auto-rename-tag" = vscode-utils.extensionFromVscodeMarketplace {
            name = "auto-rename-tag";
            publisher = "formulahendry";
            version = "0.1.10";
            sha256 = "0nyilwfs2kbf8v3v9njx1s7ppdp1472yhimiaja0c3v7piwrcymr";
          };
          "vscode-icons-team"."vscode-icons" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-icons";
            publisher = "vscode-icons-team";
            version = "12.9.0";
            sha256 = "03j4v55g68a795z6gjqza5ajddygg2vwgrs7lbib6mcwn6axkf2h";
          };
          "ms-vscode"."remote-explorer" = vscode-utils.extensionFromVscodeMarketplace {
            name = "remote-explorer";
            publisher = "ms-vscode";
            version = "0.5.2024081309";
            sha256 = "0ywbs6zrbzcmwxnwkkj2dzakbaxmdz2sf6ps6ms9mvd8iksmyk30";
          };
          "christian-kohler"."path-intellisense" = vscode-utils.extensionFromVscodeMarketplace {
            name = "path-intellisense";
            publisher = "christian-kohler";
            version = "2.9.0";
            sha256 = "1sshl8za6wviaikad8pisisn2x1y382npsh7grw3vdfi4j3awb8g";
          };
          "golang"."go" = vscode-utils.extensionFromVscodeMarketplace {
            name = "go";
            publisher = "golang";
            version = "0.43.2";
            sha256 = "00bsgmpcg7vakrjcjl6r8jpj7g9pcnnc2f8438mqyxk8hm9lnlic";
          };
          "formulahendry"."auto-close-tag" = vscode-utils.extensionFromVscodeMarketplace {
            name = "auto-close-tag";
            publisher = "formulahendry";
            version = "0.5.15";
            sha256 = "0h6nb9paw45v0shzih4486dgin64bsn889cgj9k1hjmvcqs5sm7j";
          };
          "dsznajder"."es7-react-js-snippets" = vscode-utils.extensionFromVscodeMarketplace {
            name = "es7-react-js-snippets";
            publisher = "dsznajder";
            version = "4.4.3";
            sha256 = "1xyhysvsf718vp2b36y1p02b6hy1y2nvv80chjnqcm3gk387jps0";
          };
          "donjayamanne"."githistory" = vscode-utils.extensionFromVscodeMarketplace {
            name = "githistory";
            publisher = "donjayamanne";
            version = "0.6.20";
            sha256 = "0x9q7sh5l1frpvfss32ypxk03d73v9npnqxif4fjwcfwvx5mhiww";
          };
          "batisteo"."vscode-django" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-django";
            publisher = "batisteo";
            version = "1.15.0";
            sha256 = "16s7vj4zqym74xnci60yx1rcfawq27vv3976s8vydx1asxj6q5jq";
          };
          "streetsidesoftware"."code-spell-checker" = vscode-utils.extensionFromVscodeMarketplace {
            name = "code-spell-checker";
            publisher = "streetsidesoftware";
            version = "4.0.13";
            sha256 = "0rscnclf3j1f2xxn3db99myw3jl1bxpapx4h5nd6sd85s3n20mpi";
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
          "njpwerner"."autodocstring" = vscode-utils.extensionFromVscodeMarketplace {
            name = "autodocstring";
            publisher = "njpwerner";
            version = "0.6.1";
            sha256 = "11vsvr3pggr6xn7hnljins286x6f5am48lx4x8knyg8r7dp1r39l";
          };
          "editorconfig"."editorconfig" = vscode-utils.extensionFromVscodeMarketplace {
            name = "editorconfig";
            publisher = "editorconfig";
            version = "0.16.4";
            sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
          };
          "wholroyd"."jinja" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jinja";
            publisher = "wholroyd";
            version = "0.0.8";
            sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
          };
          "donjayamanne"."python-extension-pack" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python-extension-pack";
            publisher = "donjayamanne";
            version = "1.7.0";
            sha256 = "1rvhhmbl8dn1klni3hj57fbybnsli88hip6jfncd9k0mfgmb00vv";
          };
          "yzhang"."markdown-all-in-one" = vscode-utils.extensionFromVscodeMarketplace {
            name = "markdown-all-in-one";
            publisher = "yzhang";
            version = "3.6.2";
            sha256 = "1n9d3qh7vypcsfygfr5rif9krhykbmbcgf41mcjwgjrf899f11h4";
          };
          "donjayamanne"."python-environment-manager" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python-environment-manager";
            publisher = "donjayamanne";
            version = "1.2.4";
            sha256 = "02pdq9cllnr2ih638cbhfldsw4l8v6091fxk8wp7yvpylfhywfyn";
          };
          "mechatroner"."rainbow-csv" = vscode-utils.extensionFromVscodeMarketplace {
            name = "rainbow-csv";
            publisher = "mechatroner";
            version = "3.12.0";
            sha256 = "1i453fdwjcbhn0zl8h8hmcbzf18m7r30v6qbnhlsxqfs6arxlwd6";
          };
          "aaron-bond"."better-comments" = vscode-utils.extensionFromVscodeMarketplace {
            name = "better-comments";
            publisher = "aaron-bond";
            version = "3.0.2";
            sha256 = "15w1ixvp6vn9ng6mmcmv9ch0ngx8m85i1yabxdfn6zx3ypq802c5";
          };
          "naumovs"."color-highlight" = vscode-utils.extensionFromVscodeMarketplace {
            name = "color-highlight";
            publisher = "naumovs";
            version = "2.8.0";
            sha256 = "14capk3b7rs105ij4pjz42zsysdfnkwfjk9lj2cawnqxa7b8ygcr";
          };
          "angular"."ng-template" = vscode-utils.extensionFromVscodeMarketplace {
            name = "ng-template";
            publisher = "angular";
            version = "18.2.0";
            sha256 = "0q8dl6wxzgblnd4jq5braw64pc8l5pjn7g7mgkcwh14jljg3hpdf";
          };
          "eg2"."vscode-npm-script" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-npm-script";
            publisher = "eg2";
            version = "0.3.29";
            sha256 = "10jpc4w2rzaq86c2l432z1d76d3v7scdw515y6hbk3q12sdfv84k";
          };
          "vscodevim"."vim" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vim";
            publisher = "vscodevim";
            version = "1.28.1";
            sha256 = "0cwml7z6gj2hi1hr9bzavg4zcij73lap9qgry3biv47pgwzn1gvj";
          };
          "dotjoshjohnson"."xml" = vscode-utils.extensionFromVscodeMarketplace {
            name = "xml";
            publisher = "dotjoshjohnson";
            version = "2.5.1";
            sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
          };
          "mikestead"."dotenv" = vscode-utils.extensionFromVscodeMarketplace {
            name = "dotenv";
            publisher = "mikestead";
            version = "1.0.1";
            sha256 = "0rs57csczwx6wrs99c442qpf6vllv2fby37f3a9rhwc8sg6849vn";
          };
          "shd101wyy"."markdown-preview-enhanced" = vscode-utils.extensionFromVscodeMarketplace {
            name = "markdown-preview-enhanced";
            publisher = "shd101wyy";
            version = "0.8.14";
            sha256 = "1m7f0sqynq3qjjgcgzwys7ihz709fx0xarr0qhv46kn63wyawaxw";
          };
          "tht13"."python" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python";
            publisher = "tht13";
            version = "0.2.3";
            sha256 = "1b2adxkx8akwh4638cf41lzyyr0b6qp6knirfa9y26dy7k0gf1w8";
          };
          "humao"."rest-client" = vscode-utils.extensionFromVscodeMarketplace {
            name = "rest-client";
            publisher = "humao";
            version = "0.25.1";
            sha256 = "19yc3hvhyr2na741z6ajgigxckagvfrcq3h6y958bl4107vxjb0d";
          };
          "grapecity"."gc-excelviewer" = vscode-utils.extensionFromVscodeMarketplace {
            name = "gc-excelviewer";
            publisher = "grapecity";
            version = "4.2.62";
            sha256 = "16c5l387qsx7yz38x9jaml6p1bzplc361na1x531n2i7nvq5d2rv";
          };
          "wayou"."vscode-todo-highlight" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-todo-highlight";
            publisher = "wayou";
            version = "1.0.5";
            sha256 = "1sg4zbr1jgj9adsj3rik5flcn6cbr4k2pzxi446rfzbzvcqns189";
          };
          "austin"."code-gnu-global" = vscode-utils.extensionFromVscodeMarketplace {
            name = "code-gnu-global";
            publisher = "austin";
            version = "0.2.2";
            sha256 = "1fz89m6ja25aif6wszg9h2fh5vajk6bj3lp1mh0l2b04nw2mzhd5";
          };
          "johnpapa"."angular2" = vscode-utils.extensionFromVscodeMarketplace {
            name = "angular2";
            publisher = "johnpapa";
            version = "18.0.2";
            sha256 = "12xh228s5xjywnazm97fhl2wvy6jmjpwmf57xzhk1kxrf46adyl7";
          };
          "magicstack"."magicpython" = vscode-utils.extensionFromVscodeMarketplace {
            name = "magicpython";
            publisher = "magicstack";
            version = "1.1.0";
            sha256 = "08zwzjw2j2ilisasryd73x63ypmfv7pcap66fcpmkmnyb7jgs6nv";
          };
          "alefragnani"."bookmarks" = vscode-utils.extensionFromVscodeMarketplace {
            name = "bookmarks";
            publisher = "alefragnani";
            version = "13.5.0";
            sha256 = "06pmlmd3wahplhv5r8jdk19xlv2rmhiggmmw6s30pnys2bj5va50";
          };
          "hbenl"."vscode-test-explorer" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-test-explorer";
            publisher = "hbenl";
            version = "2.22.1";
            sha256 = "1hvzrv7vaxn993imb8h40hch0svg9vrmj7a01pmqwp4hjdkbzxgs";
          };
          "ms-python"."black-formatter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "black-formatter";
            publisher = "ms-python";
            version = "2024.3.12071014";
            sha256 = "1vfchsyza1gm88xrfgis0svmq03qs25cs76h8dkdr2vjhdi5lm6c";
          };
          "james-yu"."latex-workshop" = vscode-utils.extensionFromVscodeMarketplace {
            name = "latex-workshop";
            publisher = "james-yu";
            version = "10.4.1";
            sha256 = "1hdr5wr6zrjmicpsg92ds0fh4bqs4ybzzyfv4lzprras1slkm6v5";
          };
          "ms-vscode"."test-adapter-converter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "test-adapter-converter";
            publisher = "ms-vscode";
            version = "0.1.9";
            sha256 = "0av9h6pnq9vb5c13ilywn32pfasjmd2jxaz416r4vhjs0n2f779k";
          };
          "johnpapa"."vscode-peacock" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-peacock";
            publisher = "johnpapa";
            version = "4.2.3";
            sha256 = "04a5akgdzwr05snwam7r9m9mgyani48hy4c4xx9hp8nh7ddfwn29";
          };
          "johnpapa"."winteriscoming" = vscode-utils.extensionFromVscodeMarketplace {
            name = "winteriscoming";
            publisher = "johnpapa";
            version = "1.4.4";
            sha256 = "15yqncwn2kadm4r47q8lvqk8qwasdjrrb6s7blcfi3s3nl3w5g73";
          };
          "vincaslt"."highlight-matching-tag" = vscode-utils.extensionFromVscodeMarketplace {
            name = "highlight-matching-tag";
            publisher = "vincaslt";
            version = "0.11.0";
            sha256 = "09nl6sqsjwcifl3gibirb5ypwxisl0gpxnchv51np9fjka7f069z";
          };
          "formulahendry"."auto-complete-tag" = vscode-utils.extensionFromVscodeMarketplace {
            name = "auto-complete-tag";
            publisher = "formulahendry";
            version = "0.1.0";
            sha256 = "14xmglw17wlzsil9dpbnn96kvzavfds6xmyf4s9crxydm1swpgsz";
          };
          "mikael"."angular-beastcode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "angular-beastcode";
            publisher = "mikael";
            version = "17.0.4";
            sha256 = "14c96bg4898z7gc3kd1fa68iih3wl4g51wrpah9gjxbm05yj0q25";
          };
          "adpyke"."codesnap" = vscode-utils.extensionFromVscodeMarketplace {
            name = "codesnap";
            publisher = "adpyke";
            version = "1.3.4";
            sha256 = "012sj4a65sr8014z4zpxqzb6bkj7pnhm4rls73xpwawk6hwal7km";
          };
          "zxh404"."vscode-proto3" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-proto3";
            publisher = "zxh404";
            version = "0.5.5";
            sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
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
          "foxundermoon"."shell-format" = vscode-utils.extensionFromVscodeMarketplace {
            name = "shell-format";
            publisher = "foxundermoon";
            version = "7.2.5";
            sha256 = "0a874423xw7z6zjj7gzzl39jahrrqcf2r16zbcvncw23483m3yli";
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
          "tushortz"."python-extended-snippets" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python-extended-snippets";
            publisher = "tushortz";
            version = "0.0.1";
            sha256 = "12w80d43ipwd0vwqp0frnws9yvda03yc3g54ggm60q85x01x3fmc";
          };
          "johnpapa"."angular-essentials" = vscode-utils.extensionFromVscodeMarketplace {
            name = "angular-essentials";
            publisher = "johnpapa";
            version = "18.0.0";
            sha256 = "0lkyyw6hlza8f506r2y0nlrga9vhw9cmir5j76n7xr3j0ws9s1mg";
          };
          "csstools"."postcss" = vscode-utils.extensionFromVscodeMarketplace {
            name = "postcss";
            publisher = "csstools";
            version = "1.0.9";
            sha256 = "0rbkzfa5czc7ah3ijl7hrrqiwzyyicqr2mkyzzsy9smqcwm874g6";
          };
          "pmneo"."tsimporter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "tsimporter";
            publisher = "pmneo";
            version = "2.0.1";
            sha256 = "124jyk9iz3spq8q17z79lqgcwfabbvldcq243xbzbjmbb01ds3i5";
          };
          "knisterpeter"."vscode-github" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-github";
            publisher = "knisterpeter";
            version = "0.30.7";
            sha256 = "1b1hm6z795n05mpy1b0cf0578bi8yr4d0h4w177m98ka170shz2j";
          };
          "scala-lang"."scala" = vscode-utils.extensionFromVscodeMarketplace {
            name = "scala";
            publisher = "scala-lang";
            version = "0.5.8";
            sha256 = "06yc17lxm6328qd31ldd5z4vad18znp1kmyvhsbv8p55rbp16i72";
          };
          "frhtylcn"."pythonsnippets" = vscode-utils.extensionFromVscodeMarketplace {
            name = "pythonsnippets";
            publisher = "frhtylcn";
            version = "1.0.2";
            sha256 = "0p6jvy9b0fwgainqi86cjkvzb95avyhz13rv1vq01631358i16kg";
          };
          "whatwedo"."twig" = vscode-utils.extensionFromVscodeMarketplace {
            name = "twig";
            publisher = "whatwedo";
            version = "1.0.2";
            sha256 = "0d552g0g9c5pmak4b9kjqr6z4rah276xs45lijv1hrs04jfwl8pr";
          };
          "kumar-harsh"."graphql-for-vscode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "graphql-for-vscode";
            publisher = "kumar-harsh";
            version = "1.15.3";
            sha256 = "1x4vwl4sdgxq8frh8fbyxj5ck14cjwslhb0k2kfp6hdfvbmpw2fh";
          };
          "nhoizey"."gremlins" = vscode-utils.extensionFromVscodeMarketplace {
            name = "gremlins";
            publisher = "nhoizey";
            version = "0.26.0";
            sha256 = "1sfs98nxm5ylcjrmylr5y68ddml8cfg1q1wdm7wvhfhjqx4kig9h";
          };
          "irongeek"."vscode-env" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-env";
            publisher = "irongeek";
            version = "0.1.0";
            sha256 = "1ygfx1p38dqpk032n3x0591i274a63axh992gn6z1d45ag9bs6ji";
          };
          "searking"."preview-vscode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "preview-vscode";
            publisher = "searking";
            version = "2.3.7";
            sha256 = "022ipz6izpvaflp2jcijj9xdpasx2sxjhlw7z8gbndd7kmvpd6xq";
          };
          "apollographql"."vscode-apollo" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-apollo";
            publisher = "apollographql";
            version = "2.3.2";
            sha256 = "10fhrcj793c1i66r4s4ramwf160ry44wd5pqh95nhpqi5v5jdw74";
          };
          "stkb"."rewrap" = vscode-utils.extensionFromVscodeMarketplace {
            name = "rewrap";
            publisher = "stkb";
            version = "17.8.0";
            sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
          };
          "scalameta"."metals" = vscode-utils.extensionFromVscodeMarketplace {
            name = "metals";
            publisher = "scalameta";
            version = "1.39.6";
            sha256 = "0i508ii8y47bwcfwy2jzmyqcy4mbg3zrkizpln2s1z5yfj9rsmn9";
          };
          "william-voyek"."vscode-nginx" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-nginx";
            publisher = "william-voyek";
            version = "0.7.2";
            sha256 = "0s4akrhdmrf8qwn6vp8kc31k5hx2k2wml5mcashfc09hxiqsf2cq";
          };
          "meganrogge"."template-string-converter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "template-string-converter";
            publisher = "meganrogge";
            version = "0.6.1";
            sha256 = "168v08bpkw3wgy1x67z8vjsi5hrmmh16rj8kvkqd3zr63p76jjn3";
          };
          "planbcoding"."vscode-react-refactor" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-react-refactor";
            publisher = "planbcoding";
            version = "1.1.3";
            sha256 = "18q4cah0mfn3rzswjll7z9k1p079fci5slardg7nlvbsrdn7wxjb";
          };
          "ahmadalli"."vscode-nginx-conf" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-nginx-conf";
            publisher = "ahmadalli";
            version = "0.3.5";
            sha256 = "10f5b14hlkz9gm11vxcqj6mw6nwz2lynh4z5nz2skkgn04qns0pa";
          };
          "raynigon"."nginx-formatter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "nginx-formatter";
            publisher = "raynigon";
            version = "0.0.13";
            sha256 = "0hm3zfbw0235s04aib9f2rjhl8j5n8xjvmw8ccxn2y7bgnhnks55";
          };
          "coolbear"."systemd-unit-file" = vscode-utils.extensionFromVscodeMarketplace {
            name = "systemd-unit-file";
            publisher = "coolbear";
            version = "1.0.6";
            sha256 = "0sc0zsdnxi4wfdlmaqwb6k2qc21dgwx6ipvri36x7agk7m8m4736";
          };
          "bbenoist"."vagrant" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vagrant";
            publisher = "bbenoist";
            version = "0.5.0";
            sha256 = "1fkrv6ncw752n5ni7c3p9hd7l9f2msw7rgxw07x2wigp3zd5y06x";
          };
          "peterj"."proto" = vscode-utils.extensionFromVscodeMarketplace {
            name = "proto";
            publisher = "peterj";
            version = "0.0.4";
            sha256 = "031gx0l06kgg9a8dkr5npcs5088nm5g71xg494vjzzniz9agvk1v";
          };
          "attilabuti"."vscode-mjml" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-mjml";
            publisher = "attilabuti";
            version = "1.6.0";
            sha256 = "180rvy17l0x5mg2nqkpfl6bcyqjnf72qknr521fmrkak2dp957yd";
          };
          "mike-lischke"."vscode-antlr4" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-antlr4";
            publisher = "mike-lischke";
            version = "2.4.7";
            sha256 = "06rrkf1mwppq0f9qi2nsas94gljf52xbj83376ppz7a9hgccs09x";
          };
          "plex"."vscode-protolint" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-protolint";
            publisher = "plex";
            version = "0.8.0";
            sha256 = "1212sq44gl6gnblr7rs5q74a7f93lhb0zvi99iamv4ahhi0rcchd";
          };
          "bbenoist"."nix" = vscode-utils.extensionFromVscodeMarketplace {
            name = "nix";
            publisher = "bbenoist";
            version = "1.0.1";
            sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
          };
          "jinliming2"."vscode-go-template" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-go-template";
            publisher = "jinliming2";
            version = "0.2.1";
            sha256 = "1a7v4idssmzqsf4qiv485mzh538lcm52m12gblgxyfrqw559mxcj";
          };
          "teclado"."vscode-nginx-format" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-nginx-format";
            publisher = "teclado";
            version = "0.0.6";
            sha256 = "0n35k0fzhxyvwkccvh84pvvx8yrjhn2w3vacr9by12c73hs73kk7";
          };
          "bruno-api-client"."bruno" = vscode-utils.extensionFromVscodeMarketplace {
            name = "bruno";
            publisher = "bruno-api-client";
            version = "3.1.0";
            sha256 = "0l46jafrf2mfii72gv4ikhygks1s29ys36p71517bdk2rjfj5d4c";
          };
          "gruntfuggly"."triggertaskonsave" = vscode-utils.extensionFromVscodeMarketplace {
            name = "triggertaskonsave";
            publisher = "gruntfuggly";
            version = "0.2.17";
            sha256 = "19x66z0g1v8b02dq6iay92682gkw53w041drn2z447r5xj8y27vb";
          };
          "yuanhjty"."code-template-tool" = vscode-utils.extensionFromVscodeMarketplace {
            name = "code-template-tool";
            publisher = "yuanhjty";
            version = "0.6.3";
            sha256 = "08rhd4nbcvihib1xv0ipkhjma3jvbparb4ln6b08ngydjlf4k98b";
          };
          "phobal"."vscode-collapse-node-modules" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-collapse-node-modules";
            publisher = "phobal";
            version = "1.0.5";
            sha256 = "074m3wd6jv8c9lgfb656c53bfds4wlkmg1ynggwlp8d4bhjrwdzn";
          };
          "yy0931"."go-to-next-error" = vscode-utils.extensionFromVscodeMarketplace {
            name = "go-to-next-error";
            publisher = "yy0931";
            version = "1.0.7";
            sha256 = "sha256-LIa+ka5LWPLWCGVStdLxvmOzJvWBqW1kTa72rjuDTUg=";
          };
          "amrmetwally"."vim-find-highlight" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vim-find-highlight";
            publisher = "amrmetwally";
            version = "0.0.10";
            sha256 = "13lgd1xzyskpvjalbfmldk494q65idjfbfadsn85gm037drgp8wj";
          };
          "amrmetwally"."add-arround" = vscode-utils.extensionFromVscodeMarketplace {
            name = "add-arround";
            publisher = "amrmetwally";
            version = "0.0.2";
            sha256 = "0ppiaj23y91waisidrm0pq5by1z0r6mgazcpiz16wfwld1c6x3gm";
          };
        }
        (
          lib.attrsets.optionalAttrs (isLinux && (isi686 || isx86_64)) {
            "ms-python"."python" = vscode-utils.extensionFromVscodeMarketplace {
              name = "python";
              publisher = "ms-python";
              version = "2024.15.2024091301";
              sha256 = "0rh53xnrrgm2v6z1a8w4hxmpx37l80p3fym8m92nsb4w9xk5lnpa";
              arch = "linux-x64";
            };
            "ms-toolsai"."jupyter" = vscode-utils.extensionFromVscodeMarketplace {
              name = "jupyter";
              publisher = "ms-toolsai";
              version = "2024.9.2024091101";
              sha256 = "1d05n7cd0qrw27nr3x9kyyivpcnnhb7a3dgimrp8zs8dv2a9f9mm";
              arch = "linux-x64";
            };
            "ms-vscode"."cpptools" = vscode-utils.extensionFromVscodeMarketplace {
              name = "cpptools";
              publisher = "ms-vscode";
              version = "1.22.6";
              sha256 = "16chabksxg5y6jqv0g499va6c5bia7j8v3c00cv9v1adhfywafhf";
              arch = "linux-x64";
            };
            "ms-python"."debugpy" = vscode-utils.extensionFromVscodeMarketplace {
              name = "debugpy";
              publisher = "ms-python";
              version = "2024.11.2024092501";
              sha256 = "0vpnbbvwd89ji4mg3jfrn2h2bf7y3xy4f09n0x146z735vk87z1g";
              arch = "linux-x64";
            };
            "hashicorp"."terraform" = vscode-utils.extensionFromVscodeMarketplace {
              name = "terraform";
              publisher = "hashicorp";
              version = "2.33.2024090609";
              sha256 = "0wgf5ciaa8x9py5s9s5i0cw59xs7yqwajjkrqwhs366h35kgbhvf";
              arch = "linux-x64";
            };
          }
        )
      )
      (
        lib.attrsets.optionalAttrs (isLinux && (isAarch32 || isAarch64)) {
          "ms-python"."python" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python";
            publisher = "ms-python";
            version = "2024.15.2024091301";
            sha256 = "0v2cclf16070fxzqzi6jmlg4drpdz370kp5a012w52b7jijj69kg";
            arch = "linux-arm64";
          };
          "hashicorp"."terraform" = vscode-utils.extensionFromVscodeMarketplace {
            name = "terraform";
            publisher = "hashicorp";
            version = "2.33.2024090609";
            sha256 = "1mhqk9c81cd4ggimxqvf7s041syshyxa1c3xskj1zcnp3j61811c";
            arch = "linux-arm64";
          };
        }
      )
    )
    (
      lib.attrsets.optionalAttrs (isDarwin && (isi686 || isx86_64)) {
        "ms-python"."python" = vscode-utils.extensionFromVscodeMarketplace {
          name = "python";
          publisher = "ms-python";
          version = "2024.15.2024091301";
          sha256 = "1mrmi1dqy3ivbmxij1dj91skxzsblzbing81wsk8fvyli1q8x5s3";
          arch = "darwin-x64";
        };
        "hashicorp"."terraform" = vscode-utils.extensionFromVscodeMarketplace {
          name = "terraform";
          publisher = "hashicorp";
          version = "2.33.2024090609";
          sha256 = "1h4acsdn26lfivxl9mlaahv1hassr8p16050dmlvvcyx2nszvq5x";
          arch = "darwin-x64";
        };
      }
    )
  )
  (
    lib.attrsets.optionalAttrs (isDarwin && (isAarch32 || isAarch64)) {
      "ms-python"."python" = vscode-utils.extensionFromVscodeMarketplace {
        name = "python";
        publisher = "ms-python";
        version = "2024.15.2024091301";
        sha256 = "141bal00zbh44md17nb2g5ml3m7d1khd4rym7aj51hzwwd07i8jw";
        arch = "darwin-arm64";
      };
      "hashicorp"."terraform" = vscode-utils.extensionFromVscodeMarketplace {
        name = "terraform";
        publisher = "hashicorp";
        version = "2.33.2024090609";
        sha256 = "0bqc0kvzig3bx61zv7xy07fqbxha9aw1pxbpzl40j582mhapr8qd";
        arch = "darwin-arm64";
      };
    }
  )
