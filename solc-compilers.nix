p : p.lib.foldr (a: b: let
  pname = "solc_" + (builtins.replaceStrings ["."] ["_"] a.version);
  in b // {
  "${pname}" = p.callPackage (import ./solc-bin.nix) { solc_ver = a.version; solc_sha256 = a.sha256; };
  }) {} [
  { version = "0.8.1";  sha256 = { solc-static-linux = "sha256-2qf21swKMWvrJgdTMYO2SQR5hnewy5m9oFSepw6N5ho="; }; }
  { version = "0.8.2";  sha256 = { solc-static-linux = "sha256-trlCnXHUOVkBeVk2oKruCyMIL8ruENVj2HtC5pwOaMI="; }; }
  { version = "0.8.3";  sha256 = { solc-static-linux = "sha256-+zOv12HQ1wRnHa1YLTtKeQ1NhaY3D+cbP4k1ZJaB4pI="; }; }
  { version = "0.8.4";  sha256 = { solc-static-linux = "sha256-9xFcyvEYmdzzqqiIlJ+GFEIfLRCvZadIcLz9ZwENp/g="; }; }
  { version = "0.8.5";  sha256 = { solc-static-linux = "sha256-vXggB6fVBQDSJwMUWs5tRMkWyFPNDQ/LLK6rn6X6M+c="; }; }
  { version = "0.8.6";  sha256 = { solc-static-linux = "sha256-q9XE8/JivD7XlRuWjGP5joP2bZpcNWirMG6sSSUK7D4="; }; }
  { version = "0.8.7";  sha256 = { solc-static-linux = "sha256-AD11OD5FIS+YEtC2rdkDKf07I55sN40ogvYfk0WJbZk="; }; }
  { version = "0.8.8";  sha256 = { solc-static-linux = "sha256-5nexIWsTbGHjiTSj3jqOZ94/cz16so8PBGvUoHiwy7A="; }; }
  { version = "0.8.9";  sha256 = { solc-static-linux = "sha256-+FHxH603SWuquvjWy1wFfKDZdU/dt6NRq1gNf9coy5Q="; }; }
  { version = "0.8.10"; sha256 = { solc-static-linux = "sha256-x+/6zyi51kSV+Bt1Io+/QmasDsh+jxrcSJ3dik3QbYk="; }; }
  { version = "0.8.11"; sha256 = { solc-static-linux = "sha256-cXwjnzodw6SDTBYEagtLn0aWRmXI/6ggUabQn+dBzU8="; }; }
  { version = "0.8.12"; sha256 = { solc-static-linux = "sha256-VWw+xE+vj/a2eTP6iopAOr6CyXjW5YHb/sS9BzYL+/M="; }; }
  { version = "0.8.13"; sha256 = { solc-static-linux = "sha256-qAXf+obM2O1cnNGP/PzKb/RvY1IWqn/AJGVG975BPWI="; }; }
  { version = "0.8.14"; sha256 = { solc-static-linux = "sha256-1bAnyGwPj+zAJNXU+V2OpI2KlC15lwMQ40I3BTK1AvA="; }; }
  { version = "0.8.15"; sha256 = { solc-static-linux = "sha256-UYkVXOMi1X+3XoUY2bOROWJ+3qT7JbXw6+0DkcUudMw="; }; }
  { version = "0.8.16"; sha256 = { solc-static-linux = "sha256-FjJ4bGwfhWpKiZIy7JdaEvMFEY9DzOkOck7Qsu6/7uE="; }; }
  { version = "0.8.17"; sha256 = { solc-static-linux = "sha256-mfIHC3dulxTx92xDwinPmbiXipKTjujSNkxt4RwaA9Q="; }; }
  { version = "0.8.18"; sha256 = { solc-static-linux = "sha256-lebtSUmmOtia+0Q+y6H7gwLdKGDuXpuqzj5nSg9Iqnc="; }; }
  { version = "0.8.19"; sha256 = { solc-static-linux = "sha256-elwdPcmo66Yrsuw3GSyReK5f6KVKVuVXP9PJwXzZ60g="; solc-macos = "sha256-OMhSOrZ+Cz4hxIGJ1r+5mtaHm5zgLg2ALsi+WYuyYi0="; }; }
]

