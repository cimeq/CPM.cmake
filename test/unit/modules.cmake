
include(CMakePackageConfigHelpers)
include(${CPM_PATH}/testing.cmake)

set(TEST_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/modules)

function(initProjectWithDependency TEST_DEPENDENCY_NAME)
  configure_package_config_file(
    "${CMAKE_CURRENT_LIST_DIR}/local_dependency/ModuleCMakeLists.txt.in"
    "${CMAKE_CURRENT_LIST_DIR}/local_dependency/CMakeLists.txt"
    INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/junk
  )

  execute_process(
    COMMAND 
    ${CMAKE_COMMAND} "-H${CMAKE_CURRENT_LIST_DIR}/local_dependency" "-B${TEST_BUILD_DIR}"
    RESULT_VARIABLE ret
  )

  ASSERT_EQUAL(${ret} "0")
endfunction()

initProjectWithDependency(A)
ASSERT_EXISTS(${TEST_BUILD_DIR}/CPM_modules)
ASSERT_EXISTS(${TEST_BUILD_DIR}/CPM_modules/FindA.cmake)
ASSERT_NOT_EXISTS(${TEST_BUILD_DIR}/CPM_modules/FindB.cmake)

initProjectWithDependency(B)
ASSERT_NOT_EXISTS(${TEST_BUILD_DIR}/CPM_modules/FindA.cmake)
ASSERT_EXISTS(${TEST_BUILD_DIR}/CPM_modules/FindB.cmake)
