include(Download)
include(ExternalProject)

#TODO: update the message below to make it suitable for the new logic.
message(STATUS "Downloading PACE") 


#Searches for the horace_version.m file to check whether horace can be found in the provided dir
#ISSUE: different horace versions may have different dir structure  
if(HORACE_PATH AND WITH_HORACE)
    find_file(HORACE_FOUND 
        NAMES "horace_version.m"
        PATHS "${HORACE_PATH}/horace_core/admin"
        NO_CACHE
        )

    message(STATUS "HORACE_FOUND variable contains ${HORACE_FOUND}")

    if(NOT HORACE_FOUND)
        message(FATAL_ERROR "Horace may not exist at ${HORACE_PATH}") #TODO: write a better message
    # else()
    #     message(FATAL_ERROR "Horace was found.")
    endif()
endif()

if(SPINW_PATH AND WITH_SPINW)
    find_file(SPINW_FOUND
        NAMES "install_spinw.m"
        PATHS "${SPINW_PATH}"
        NO_CACHE
    )

    message(STATUS "SPINW_FOUND variable contains ${SPINW_FOUND}")

    if(NOT SPINW_FOUND)
        message(FATAL_ERROR "SpinW may not exist at ${SPINW_PATH}") #TODO: write a better message
    # else()
    #     message(FATAL_ERROR "SpinW was found.")
    endif()
endif()


if(WITH_SPINW)
    if(SPINW_PATH)
        #TODO: Set ExternalProject_Add up correctly for SpinW
        #ISSUE: Currently does not actualy have anyway to check if SpinW is in the dir specified
        ExternalProject_Add(SpinW 
            SOURCE_DIR "${SPINW_PATH}"
            #INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/CTF"
            DOWNLOAD_COMMAND ""
            #INSTALL_COMMAND ""
            )
        #message(FATAL_ERROR "Successfully included ${SPINW_PATH}") #check this
    else()
        message(STATUS "Downloading SpinW")
        download(
            PROJ SPINW
            GIT_REPOSITORY https://github.com/${SPINW_REPO}.git
            GIT_TAG ${SPINW_VERSION}
            GIT_SHALLOW 1
        )
    endif()
endif()

if(WITH_HORACE)
    if(HORACE_PATH)
        ExternalProject_Add(HORACE 
            SOURCE_DIR ${HORACE_PATH}
            #INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/CTF"
            DOWNLOAD_COMMAND "" #empty quotation marks effectively disables the download feature of ExternalProject_Add
            CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/CTF"
            #INSTALL_COMMAND ""
            )

        #message(FATAL_ERROR "Successfully included external Horace")
    else()
        message(STATUS "Downloading Horace")
        if(WIN32)
            download(
                PROJ HORACE
                URL https://github.com/pace-neutrons/Horace/releases/download/v${HORACE_VERSION}/Horace-${HORACE_VERSION}-win64-R2019b.zip
                BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/CTF"
            )
        else()
            download(
                PROJ HORACE
                URL https://github.com/pace-neutrons/Horace/releases/download/v${HORACE_VERSION}/Horace-${HORACE_VERSION}-linux-R2019b.tar.gz
                BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/CTF"
            )
        endif()
    endif()
endif()