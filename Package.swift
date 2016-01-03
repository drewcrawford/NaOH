import PackageDescription

let package = Package(
    name: "NaOH",
    targets: [Target(name: "NaOH")],
    otherCompilerOptions:["-I", "CSodium/",
    "-Xcc", "-fblocks" //⛏397
    ], 
    exclude: ["NaOHiOSTestHostApp","NaOHiOSTestHostAppTests", "NaOHTests"],
    preflight: "preflight.sh"
)