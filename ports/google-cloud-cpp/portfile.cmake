if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    message(STATUS "Warning: Dynamic building not supported yet. Building static.")
    set(VCPKG_LIBRARY_LINKAGE static)
endif()

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GoogleCloudPlatform/google-cloud-cpp
    REF v0.2.0
    SHA512 ded3b564ef264a8bff4d81b08f2a97462e063127bf75a006bc7b18d18cfaee2f3cbe5957fe2c56cec06da5a7765854444fad8cd5045579c416c5f3de8462382e
    HEAD_REF master
    PATCHES
        "${CMAKE_CURRENT_LIST_DIR}/include-protobuf.patch"
)

set(GOOGLEAPIS_VERSION 92f10d7033c6fa36e1a5a369ab5aa8bafd564009)
vcpkg_download_distfile(GOOGLEAPIS
    URLS "https://github.com/google/googleapis/archive/92f10d7033c6fa36e1a5a369ab5aa8bafd564009.zip"
    FILENAME "googleapis-${GOOGLEAPIS_VERSION}.zip"
    SHA512 4280ece965a231f6a0bb3ea38a961d15babd9eac517f9b0d57e12f186481bbab6a27e4f0ee03ba3c587c9aa93d3c2e6c95f67f50365c65bb10594f0229279287
)

file(REMOVE_RECURSE ${SOURCE_PATH}/third_party)
vcpkg_extract_source_archive(${GOOGLEAPIS} ${SOURCE_PATH}/third_party)
file(RENAME ${SOURCE_PATH}/third_party/googleapis-${GOOGLEAPIS_VERSION} ${SOURCE_PATH}/third_party/googleapis)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DGOOGLE_CLOUD_CPP_GRPC_PROVIDER=vcpkg
        -DGOOGLE_CLOUD_CPP_GMOCK_PROVIDER=vcpkg
)

vcpkg_install_cmake(ADD_BIN_TO_PATH)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/bigtable/client/testing)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_fixup_cmake_targets(CONFIG_PATH share/cmake TARGET_PATH share/bigtable_client)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/google-cloud-cpp RENAME copyright)

vcpkg_copy_pdbs()
