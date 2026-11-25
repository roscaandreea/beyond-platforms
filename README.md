# Beyond Platforms

Andreea Rosca’s Flutter Web portfolio based on the approved Platform Index design. The app uses Material 3, local fonts, dark and light palettes, and a feature-first layout under `lib/features`.

## Local development

Use Flutter 3.50.1. From this directory, run:

```sh
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
flutter build web --release --base-href /beyond-platforms/
```

The local web server defaults to [http://localhost:3000/](http://localhost:3000/).

Desktop and tablet highlight a selected preview within the three-device composition. Mobile displays a single preview. The device entrance and switching respect the platform’s reduced-motion preference. Education and contact come from the legacy portfolio.

## GitHub Pages

Pull requests and pushes to `main` run analysis, tests, and a release build. To publish this repository, set **Settings → Pages → Build and deployment → Source** to **GitHub Actions**, then run the **Flutter Web on GitHub Pages** workflow manually from `main`.

The build uses `/beyond-platforms/` for this repository’s Pages URL. The [legacy React portfolio](https://roscaandreea.github.io/myPortofolio/) is hosted separately.

[GitHub Pages publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
