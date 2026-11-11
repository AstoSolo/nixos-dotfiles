{ ... }: {
  age.identityPaths = [ "/var/lib/agenix/key.txt" ];

  age.secrets = {
    wifi.file = ../../secrets/wifi.age;

    nextcloud = {
      file = ../../secrets/nextcloud.age;
      owner = "astosolo";
      mode = "0400";
    };
  };
}
