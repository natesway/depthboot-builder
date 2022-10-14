#!/usr/bin/env python3

from functions import *
import build

if __name__ == "__main__":
    print_header("Starting Fedora tests")
    set_verbose(True)

    testing_dict = {
        "distro_name": "fedora",
        "distro_version": "36",
        "distro_link": "",
        "de_name": "",
        "username": "localuser",
        "password": "test",
        "hostname": "depthboot-chromebook",
        "device": "image",
        "rebind_search": False
    }
    available_des = ["gnome", "kde", "mate", "xfce", "lxqt", "deepin", "cli"]  # budgie is not available for fedora
    failed_distros = []
    # Start testing
    for de_name in available_des:
        testing_dict["de_name"] = de_name
        print_header(f"Testing Fedora + {de_name}")
        try:
            build.start_build(verbose=True, local_path="", kernel_type="stable", dev_release=False,
                              build_options=testing_dict)
        except:
            print_error(f"Failed to build Fedora + {de_name}")
            failed_distros.append(de_name)

    with open("results.txt", "w") as f:
        f.write(str(failed_distros))