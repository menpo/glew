cmake_minimum_required(VERSION 2.8)
project(GLEW)


set(GLEW_NAME "GLEW")
set(GLEW_VERSION "@glew_version@")
string(REGEX REPLACE "^([0-9]+\\.[0-9]+)\\.[0-9]+$" "\\1"
  GLEW_SOVERSION "${GLEW_VERSION}")

# Platform specific differences:
if(APPLE)
  set(platform_libs "-framework AGL" "-framework OpenGL")
elseif(WIN32)
  set(GLEW_NAME "glew32")
  set(platform_libs glu32 opengl32)
else()
  # any platform_libs required on Linux or other platforms?
  find_package(OpenGL REQUIRED)
  set(platform_libs ${OPENGL_LIBRARIES})
endif()

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/include")

# The add_library calls build either STATIC or SHARED, depending on the
# value of BUILD_SHARED_LIBS. We could mimic GLEW's Makefile and build
# both if necessary...
add_library(${GLEW_NAME} src/glew.c)
set_property(TARGET ${GLEW_NAME} PROPERTY COMPILE_DEFINITIONS GLEW_NO_GLU)
if(BUILD_SHARED_LIBS)
  set_property(TARGET ${GLEW_NAME} APPEND PROPERTY COMPILE_DEFINITIONS GLEW_EXPORTS)
else()
  set_property(TARGET ${GLEW_NAME} APPEND PROPERTY COMPILE_DEFINITIONS GLEW_STATIC)
endif()
set_property(TARGET ${GLEW_NAME} PROPERTY VERSION ${GLEW_VERSION})
set_property(TARGET ${GLEW_NAME} PROPERTY SOVERSION ${GLEW_SOVERSION})
if(platform_libs)
  target_link_libraries(${GLEW_NAME} ${platform_libs})
endif()

add_library(${GLEW_NAME}mx src/glew.c)
set_property(TARGET ${GLEW_NAME}mx PROPERTY COMPILE_DEFINITIONS GLEW_NO_GLU GLEW_MX)
if(BUILD_SHARED_LIBS)
  set_property(TARGET ${GLEW_NAME}mx APPEND PROPERTY COMPILE_DEFINITIONS GLEW_EXPORTS)
else()
  set_property(TARGET ${GLEW_NAME}mx APPEND PROPERTY COMPILE_DEFINITIONS GLEW_STATIC)
endif()
set_property(TARGET ${GLEW_NAME}mx PROPERTY VERSION ${GLEW_VERSION})
set_property(TARGET ${GLEW_NAME}mx PROPERTY SOVERSION ${GLEW_SOVERSION})
if(platform_libs)
  target_link_libraries(${GLEW_NAME}mx ${platform_libs})
endif()


install(FILES
    include/GL/glew.h
    include/GL/glxew.h
    include/GL/wglew.h
  DESTINATION include/GL
  )

# Leaving the *.pc files out of the install, since we don't use pkgconfig
# to tell us how to build against GLEW anyhow.
# install(FILES
#     glew.pc
#     glewmx.pc
#   DESTINATION pkgconfig
#   )

install(TARGETS
    ${GLEW_NAME}
    ${GLEW_NAME}mx
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )