# multiple-analytics-flutter

This is the complete code example for the article [Article Name]().

To start, clone the repository and create a copy of the `.env.example` file named `.env` and fill in the values.

```bash
cp .env.example .env
```

Then add your Mixpanel token and run the `build_runner` to generate the code.

```bash
flutter run build_runner build -d
```

Make sure to also initialize PostHog on the platforms that you are using it.

Finally, run the app.