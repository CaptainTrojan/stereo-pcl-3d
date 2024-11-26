import subprocess
import os

def main():
    # Define the path to the entrypoint.sh script
    entrypoint_script = "/workspace/mmdetection3d/entrypoint.sh"

    # Ensure the script is executable
    os.chmod(entrypoint_script, 0o755)

    # Run the entrypoint.sh script and capture the output
    result = subprocess.run([entrypoint_script], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Output the stdout and stderr
    print("stdout:", result.stdout)
    print("stderr:", result.stderr)

    # Check the result
    if result.returncode == 1:
        print(f"Script {entrypoint_script} exited with code 1, but not raising an error.")
    elif result.returncode != 0:
        print(f"Script {entrypoint_script} failed with return code {result.returncode}")
        exit(result.returncode)
    else:
        print(f"Script {entrypoint_script} executed successfully")

if __name__ == "__main__":
    main()