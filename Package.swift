// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Aquarius",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Aquarius",
            targets: ["Aquarius"]),
    ],
    targets: [
        .target(
            name: "Aquarius",
            path: "Aquarius" // 你的源代码目录
        )
    ]
)
