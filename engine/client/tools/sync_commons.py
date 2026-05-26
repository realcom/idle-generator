import os
import shutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# A 폴더 경로와 B 폴더 경로를 설정합니다.
source_dir = "../../idlez-server/Server/Commons"  # A 폴더의 절대경로
target_dir = "../Client/Assets/Scripts/Commons"  # A 폴더의 절대경로

class SyncHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.is_directory:
            return
        self.sync_files()

    def on_created(self, event):
        if event.is_directory:
            return
        self.sync_files()

    def sync_files(self):
        # A 폴더 내용을 B 폴더로 동기화
        for root, _, files in os.walk(source_dir):
            for file in files:
                if self.should_ignore(file, root):
                    continue

                source_file = os.path.join(root, file)
                relative_path = os.path.relpath(source_file, source_dir)
                target_file = os.path.join(target_dir, relative_path)

                if not os.path.exists(target_file) or os.path.getmtime(source_file) > os.path.getmtime(target_file):
                    print('syncing ...' + source_file)
                    os.makedirs(os.path.dirname(target_file), exist_ok=True)
                    shutil.copy2(source_file, target_file)  # 파일 복사

    @staticmethod
    def should_ignore(file_name, folder_path, from_target=False):
        
        if file_name.endswith(".git"):
            return True
        if file_name.endswith(".meta"):
            return True
        if ".git" in folder_path:
            return True
        if from_target and os.path.join(target_dir, ".git") in folder_path:
            return True
        return False


if __name__ == "__main__":
    event_handler = SyncHandler()
    observer = Observer()
    observer.schedule(event_handler, source_dir, recursive=True)
    observer.start()

    try:
        print("폴더 동기화를 시작합니다...")
        while True:
            pass
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
