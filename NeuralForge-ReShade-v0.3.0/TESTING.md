# Test checklist

- [ ] Confirm ReShade is installed for the correct FFXIV executable and graphics API.
- [ ] Confirm the configured shader search path includes this package's `Shaders` folder (or copy the `.fx` file into the configured folder).
- [ ] Reload effects and verify `NeuralForge` appears.
- [ ] Enable the technique and check for compiler errors in the ReShade log.
- [ ] Compare with the effect disabled/enabled in a static scene and in motion.
- [ ] Check for sharpening halos, flicker, excessive contrast, or blown highlights.
- [ ] Record ReShade version, graphics API, and exact compiler message for any failure.

This package has not yet been confirmed to compile in a live game session.
