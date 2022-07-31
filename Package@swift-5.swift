// swift-tools-version:5.0

import PackageDescription

var package = Package(
  name: "Lighter",

  platforms: [ .macOS(.v10_14), .iOS(.v12) ],
  
  products: [
    .library(name: "Lighter",         targets: [ "Lighter"       ]),
    .library(name: "SQLite3Schema",   targets: [ "SQLite3Schema" ])
  ],
  
  targets: [
    // A small library used to fetch schema information from SQLite3 databases.
    .target(name: "SQLite3Schema", exclude: [ "README.md" ]),
    
    // Lighter is a shared lib providing common protocols used by Enlighter
    // generated models and such.
    // Note that Lighter isn't that useful w/o code generation (i.e. as a
    // standalone lib).
    .target(name: "Lighter"),

    
    // MARK: - Plugin Support
    
    // The CodeGenAST is a small and hacky helper lib that can format/render
    // Swift source code.
    .target(name    : "LighterCodeGenAST",
            path    : "Plugins/Libraries/LighterCodeGenAST",
            exclude : [ "README.md" ]),
    
    
    // MARK: - Tests
    
    .testTarget(name: "CodeGenASTTests", dependencies: [ "LighterCodeGenAST" ])
  ]
)

#if !(os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
package.products += [ .library(name: "SQLite3", targets: [ "SQLite3" ]) ]
package.targets += [
  .systemLibrary(name: "SQLite3",
                 path: "Sources/SQLite3-Linux",
                 providers: [ .apt(["libsqlite3-dev"]) ])
]
package.targets
  .first(where: { $0.name == "SQLite3Schema" })?
  .dependencies.append("SQLite3")
package.targets
  .first(where: { $0.name == "Lighter" })?
  .dependencies.append("SQLite3")
#endif // not-Darwin
