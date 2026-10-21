/// Orientation of the device UI at the exact moment a guided photo is taken.
///
/// Kept in the domain layer so perspective code does not depend on the camera
/// plugin's [DeviceOrientation] enum.
enum CaptureRotation {
  portraitUp,
  landscapeLeft,
  portraitDown,
  landscapeRight,
}
