Nix convenience scripts.

  * `ddl`: describe derivations dependent on `nix-store`d shared object files;
    the inverse of `ldd`:

    ```
    % ddl /nix/store/x0advqg4yky9iyc2f2yfp77g44f8bn49-libXinerama-1.1.3/lib/libXinerama.so.1.0.0 
    /nix/store/39h1msyil0g1aix9jzbg42haha1hmhnl-gtk+3-3.12.2.drv
    /nix/store/jpjv5iaks49sds1xa0a1mcjyj2p290kx-gtk+-2.24.25.drv
    ```
