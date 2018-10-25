include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(VCPKG_LIBRARY_LINKAGE "static")
    message("CAF only supports static library linkage")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO actor-framework/actor-framework
    REF 0.16.0
    SHA512 602cc73471494eb574caeda4aed649d42c24c4f6a9f4862761db56c1990afa5525bcf34b9abb61b9dad261781b54a6d8e276f6358ed3283c9b78121465e60102
    HEAD_REF master
    PATCHES openssl-version-override.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
        -DCAF_BUILD_STATIC=ON
        -DCAF_BUILD_STATIC_ONLY=ON
        -DCAF_NO_TOOLS=ON
        -DCAF_NO_EXAMPLES=ON
        -DCAF_NO_BENCHMARKS=ON
        -DCAF_NO_UNIT_TESTS=ON
        -DCAF_NO_PROTOBUF_EXAMPLES=ON
        -DCAF_NO_QT_EXAMPLES=ON
        -DCAF_NO_OPENCL=ON
        -DCAF_NO_OPENSSL=OFF
        -DCAF_NO_CURL_EXAMPLES=ON
        -DCAF_OPENSSL_VERSION_OVERRIDE=ON
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/caf RENAME copyright)

vcpkg_copy_pdbs()
