from whiptail import Whiptail

w = Whiptail(title="Arch Linux Rice Installer", backtitle="Automated Arch Rice Setup")

intro = (
    "Welcome to the Arch Linux Rice Installer!\n\n"
    "This tool will guide you through the setup process for your Arch Linux system.\n"
    "You will be asked to provide the following information:\n"
    "  • Username\n"
    "  • Hostname\n"
    "  • Password\n\n"
    "After confirming, the installation process will begin, and your system will be configured with the provided rice setup."
)
w.msgbox(intro)

username = ""
hostname = ""
password = ""

while True:
    choice = w.menu(
        "Edit fields then choose “Confirm”.",
        [
            (f"Username", f"{username or '<empty>'}"),
            (f"Hostname", f"{hostname or '<empty>'}"),
            (f"Password", f"{'*' * len(password) if password else '<empty>'}"),
            ("———", "———————————————"),
            ("Confirm & Continue", "Proceed with these values"),
            ("Cancel", "Abort setup"),
        ],
    )[0]

    if choice == "Username":
        username = (w.inputbox("Enter the username for the new system:")[0] or "").strip()
    elif choice == "Hostname":
        hostname = (w.inputbox("Enter the hostname for the new system:")[0] or "").strip()
    elif choice == "Password":
        password = (w.inputbox("Enter the password for the new user:", password=True)[0] or "")
    elif choice == "Confirm & Continue":
        errors = []
        if not username:
            errors.append("• Username is empty")
        if not hostname:
            errors.append("• Hostname is empty")
        if not password:
            errors.append("• Password is empty")

        if errors:
            w.msgbox("Please fix the following:\n\n" + "\n".join(errors))
            continue

        summary = (
            "Please confirm the information:\n\n"
            f"Username: {username}\n"
            f"Hostname: {hostname}\n"
            f"Password: {'*' * len(password)}\n\n"
            "Is this correct?"
        )
        if w.yesno(summary):
            w.msgbox("Thank you. Proceeding with the installation...")
            break
    else:
        w.msgbox("Installation cancelled.")
        raise SystemExit(1)

print(f"USERNAME={username}")
print(f"HOSTNAME={hostname}")
print(f"PASSWORD={password}")

w.msgbox(
    "The installation process will now begin. Please do not turn off your computer.\n\n"
    "This may take some time. Logs will be displayed in the terminal."
)

# subprocess.run(["bash", "path/to/installation/script.sh", username, hostname, password])
