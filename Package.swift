// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Paysafe_SDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Paysafe_SDK",
            targets: ["Paysafe_SDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "CardinalMobile",
            path: "Frameworks/CardinalMobile.xcframework"
        ),
        .target(
            name: "Paysafe_SDK",
            dependencies: ["CardinalMobile"],
            path: "Paysafe_SDK",
            exclude: [
                "Info.plist",
                "Paysafe_SDK.h"
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                .process("paysafe_sdk_versioning-Info.plist")
            ]
        ),
        .testTarget(
            name: "Paysafe_SDKTests",
            dependencies: [
                "Paysafe_SDK",
                "CardinalMobile"
            ],
            path: "Paysafe_SDKTests",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)
