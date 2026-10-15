# NeuralForge by Void — ReShade Edition

Version: 0.3.0 test build  
Target: ReShade post-processing for Final Fantasy XIV

## Installation

1. Install ReShade for the FFXIV executable you actually launch.
2. Copy `Shaders/NeuralForge_ReShade.fx` into the shader folder configured in ReShade's settings.
3. In the ReShade overlay, open Settings and confirm the shader search path points to that folder; reload the effect list.
4. Enable `NeuralForge` in the Home overlay.
5. To use a preset, copy one of the `.ini` files into your preset folder and select it in the overlay. If your ReShade version stores presets differently, use the values in the file as a guide.

## What's included

- A single-pass screen-space detail/contrast shader.
- Starter and cinematic-style parameter presets.
- Adjustable detail, edge clarity, local contrast, soft lighting, highlight approximation, color richness, and blend strength.

## Important limitations

This is a conventional screen-space post-processing shader, not a neural network. It cannot identify character materials, selectively change clothing transparency, infer actual fabric properties, alter geometry, or guarantee a specific trailer look. The `Fabric Sheen` slider is only a broad brightness-based image approximation and may affect other bright areas.

**Testing status:** source package prepared, but compilation and in-game rendering have not been verified in the user's ReShade/FFXIV setup. If compilation fails, check the ReShade log and share the exact error and line number so the source can be corrected for that installed version.

## Troubleshooting

- If the effect is not listed, verify the shader search path and reload effects.
- If `ReShade.fxh` cannot be found, the shader directory/include configuration is not set up as expected.
- If compilation fails, capture the complete error from the ReShade log rather than guessing at the cause.

## License

MIT License. See `LICENSE`.
