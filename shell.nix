{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    jdk21
    gradle
    kotlin
    maven
    plantuml
    graphviz
    sqlite
  ];

  JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  GRAPHVIZ_DOT = "${pkgs.graphviz}/bin/dot";

  shellHook = '' 
    export GRADLE_OPTS="-Dorg.gradle.jvmargs=-Xmx1g"
    echo "JDK 21 + Gradle + Kotlin + Maven + PlantUML + SQLite dev environment ready"
  '';
}
