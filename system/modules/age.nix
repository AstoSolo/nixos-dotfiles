{ ... }: {
  age.identityPaths = [ "/var/lib/agenix/key.txt" ];

  age.secrets = {
    wifi.file = ../../secrets/wifi.age;
  };
}
