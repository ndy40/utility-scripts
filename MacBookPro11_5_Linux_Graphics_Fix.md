# Linux Graphics Fix — MacBookPro11,5 (2015)

## Hardware

- **Model:** Apple MacBook Pro 11,5 (15-inch, 2015)
- **Discrete GPU:** AMD Radeon R9 M370X Mac Edition
- **Integrated GPU:** Intel Iris Pro
- **Problem:** Large/partial blank white area on the desktop; newer kernels can fail during graphics initialization and leave a black screen.

## Known-good configuration

The following configuration was confirmed during testing:

- **Kernel 6.14.0-37:** works with `intel_iommu=off`
- **Kernel 7.0.0-30:** works with the AMD `radeon` driver when `amdgpu` is disabled
- **Do NOT use `nomodeset` as the final configuration** because it results in `llvmpipe` software rendering.
- **Do NOT remove the working older kernel.** Keep it as a fallback.

### Final kernel parameters

```text
intel_iommu=off modprobe.blacklist=amdgpu radeon.si_support=1
```

Recommended GRUB line:

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=off modprobe.blacklist=amdgpu radeon.si_support=1"
```

## Why these parameters are used

### `intel_iommu=off`

This was directly tested and **fixed the white/blank desktop problem**.

Without it:
- Desktop contained a large/partial white area.

With it:
- Desktop rendered normally.

### `modprobe.blacklist=amdgpu`

On kernel 7.0.0-30, normal graphics initialization caused the machine to go black. The boot log showed:

```text
amdgpu - Runtime PM not available
VCE busy VCE_STATUS=0x100
```

Preventing `amdgpu` from loading allowed the system to boot.

### `radeon.si_support=1`

With `amdgpu` disabled, the older `radeon` driver successfully handled the AMD GPU.

The Mesa renderer reported:

```text
Verde (radeonsi, ...)
```

This is important because it indicates **hardware-accelerated Radeon rendering**, rather than software rendering through `llvmpipe`.

### Do not use `nomodeset` as the final fix

`nomodeset` allowed kernel 7.0 to boot, but:

```text
OpenGL renderer string: llvmpipe
```

was reported.

`llvmpipe` means software/CPU rendering, so this is only useful as a diagnostic workaround, not as the preferred configuration.

## Recreating the configuration on a new distro

After installing the distro:

### 1. Check the kernel

```bash
uname -r
```

### 2. Edit GRUB

On Ubuntu/Mint/Debian-based systems:

```bash
sudo nano /etc/default/grub
```

Set:

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=off modprobe.blacklist=amdgpu radeon.si_support=1"
```

Then update GRUB:

```bash
sudo update-grub
```

Reboot:

```bash
sudo reboot
```

## Verify the AMD driver

Run:

```bash
lsmod | grep -E 'amdgpu|radeon|i915'
```

Expected result:
- `radeon` should be loaded.
- `i915` may be loaded because the Mac has Intel graphics.
- `amdgpu` should **not** be loaded.

Then:

```bash
lspci -nnk -s 01:00.0
```

Look for:

```text
Kernel driver in use: radeon
```

## Verify hardware acceleration

Install Mesa utilities if necessary:

```bash
sudo apt install mesa-utils
```

Then:

```bash
glxinfo -B
```

Check:

```text
OpenGL renderer string:
```

The working test produced a renderer containing:

```text
Verde (radeonsi, ...)
```

Avoid a result containing:

```text
llvmpipe
```

because that indicates software rendering.

## Kernel troubleshooting

The following behavior was observed:

| Configuration | Result |
|---|---|
| Kernel 6.14.0-37 + `intel_iommu=off` | **Works** |
| Kernel 7.0.0-30 + `intel_iommu=off` | **Does not boot normally** |
| Kernel 7.0.0-30 + `intel_iommu=off nomodeset` | Boots, but uses `llvmpipe` |
| Kernel 7.0.0-30 + AMDGPU disabled | Boots |
| Kernel 7.0.0-30 + AMDGPU disabled + Radeon | **Boots with accelerated `radeonsi` rendering** |

A different Linux distribution previously worked with **kernel 6.17**, while newer kernels had boot problems.

### Important fallback

Always keep a known-good kernel available.

For this machine, the known-good tested fallback from this troubleshooting session is:

```text
6.14.0-37
```

If a newer kernel fails, select the older kernel from GRUB's:

```text
Advanced options for Linux
```

## If the machine fails to boot after a new kernel

At the GRUB menu:

1. Highlight the problematic kernel.
2. Press `e`.
3. Temporarily add:

```text
intel_iommu=off modprobe.blacklist=amdgpu radeon.si_support=1
```

4. Boot with **Ctrl+X** or **F10**.

If that still fails, try the known-good older kernel.

For diagnostic purposes only, `nomodeset` can be added, but remember that it may result in `llvmpipe` software rendering.

## Useful diagnostic commands

### Kernel

```bash
uname -a
```

### Kernel command line

```bash
cat /proc/cmdline
```

Confirm that it contains:

```text
intel_iommu=off
modprobe.blacklist=amdgpu
radeon.si_support=1
```

### GPUs and drivers

```bash
lspci -nnk | grep -A4 -E 'VGA|3D|Display'
```

### Loaded graphics modules

```bash
lsmod | grep -E 'amdgpu|radeon|i915'
```

### OpenGL renderer

```bash
glxinfo -B
```

### Relevant kernel messages

```bash
sudo dmesg | grep -Ei 'amdgpu|radeon|i915|drm|iommu|gpu|gmux'
```

or:

```bash
journalctl -b -k | grep -Ei 'amdgpu|radeon|i915|drm|gpu|iommu'
```

## Short version

For this **2015 MacBook Pro 11,5 with Radeon R9 M370X**, the configuration established during troubleshooting was:

```text
intel_iommu=off modprobe.blacklist=amdgpu radeon.si_support=1
```

Use the **`radeon` driver rather than `amdgpu`** for the M370X on the affected newer kernel configuration.

The most important rule is:

> **Keep a known-good older kernel installed, and avoid `nomodeset` as a permanent solution.**
