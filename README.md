# sunday 11:19 -> 13:39 - 19:10

# Pre-requisites

- Flutter SDK installed
- Android Emulator or physical device connected
- `make` (optional, for easier commands)

# Radio

- Clone the repository

```bash
git clone https://github.com/cgutierr-zgz/radio.git
```

- Change directory to the project folder

```bash
cd radio
```

- Install the dependencies

```bash
flutter pub get
```

- Run the app

```bash
flutter run
# or
make run
```

# Running the tests

- Run the tests

```bash
flutter test
# or
make test
```

# Code generation

This project uses code generation for some parts of the code. To generate the
code, run the following command:

- Generate code once:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
# or
make gen
```

- Watch for changes and generate code automatically:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
# or
make watch
```

# Radio API
We fetch radio stations using the Radio Browser API:

API documentation: https://de1.api.radio-browser.info
