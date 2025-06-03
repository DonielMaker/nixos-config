{
    services.xserver.videoDriver = [ "amdgpu" ];
    hardware.amdgpu.opencl.enable = true;
    hardware.amdgpu.initrd.enable = true;
    hardware.amdgpu.overdrive.enable = true;
}
