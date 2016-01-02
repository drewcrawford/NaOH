import PackageDescription

let package = Package(
    name: "NaOH",
    targets: [Target(name: "NaOH", extraIncludes: ["CSodium"])],
    exclude: ["NaOHiOSTestHostApp","NaOHiOSTestHostAppTests", "NaOHTests"],
    preflight: "preflight.sh"
)