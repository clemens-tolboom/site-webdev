// #docregion
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

import 'hero.dart';
import 'hero_detail_component.dart';
import 'hero_form_component.dart';
import 'hero_switch_components.dart';
import 'click_directive.dart';
import 'sizer_component.dart';

// Alerter fn: monkey patch during test
void alerter(String msg) {
  window.alert(msg);
}

enum Color { red, green, blue }

/// Giant grab bag of stuff to drive the chapter
@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [
      BigHeroDetailComponent,
      HeroDetailComponent,
      HeroFormComponent,
      heroSwitchComponents,
      ClickDirective,
      ClickDirective2,
      SizerComponent,
      materialDirectives
    ],
  providers: const [materialProviders],
)
class AppComponent implements AfterViewInit, OnInit {

  @override
  void ngOnInit() {
    resetHeroes();
    setCurrentClasses();
    setCurrentStyles();
  }

  @override
  void ngAfterViewInit() {
    // Detect effects of NgForTrackBy
    trackChanges(heroesNoTrackBy,   () => heroesNoTrackByCount++);
    trackChanges(heroesWithTrackBy, () => heroesWithTrackByCount++);
  }

  @ViewChildren('noTrackBy') QueryList<ElementRef> heroesNoTrackBy;
  @ViewChildren('withTrackBy') QueryList<ElementRef> heroesWithTrackBy;

  String actionName = 'Go for it';
  Function alert = alerter;
  String badCurly = 'bad curly';
  String classes = 'special';
  String help = '';

  void callFax(String value) => alert('Faxing $value ...');
  void callPhone(String value) => alert('Calling $value ...');
  bool canSave = true;

  void changeIds() {
    this.resetHeroes();
    this.heroes.map((h) => h.id += 10 * this.heroIdIncrement++).toList();
    this.heroesWithTrackByCountReset = -1;
  }

  void clearTrackByCounts() {
    final trackByCountReset = this.heroesWithTrackByCountReset;
    this.resetHeroes();
    this.heroesNoTrackByCount = -1;
    this.heroesWithTrackByCount = trackByCountReset;
    this.heroIdIncrement = 1;
  }

  String clicked = '';
  String clickMessage = '';
  String clickMessage2 = '';

  final Color colorRed = Color.red;
  Color color = Color.red;
  void colorToggle() {
    color = (color == Color.red) ? Color.blue : Color.red;
  }

  Hero currentHero;

  void deleteHero([Hero hero]) {
    alerter('Deleted ${hero?.name ?? 'the hero'}.');
  }

  // #docregion evil-title
  String evilTitle = 'Template <script>alert("evil never sleeps")</script>Syntax';
  // #enddocregion evil-title

  var/*String|int*/ fontSizePx = '16';
  
  String title = 'Template Syntax';

  int getVal() => 2;

  String name = Hero.mockHeroes[0].name;
  Hero hero; // defined to demonstrate template context precedence
  List<Hero> heroes;

  // trackBy change counting
  int heroesNoTrackByCount   = 0;
  int heroesWithTrackByCount = 0;
  int heroesWithTrackByCountReset = 0;

  int heroIdIncrement = 1;

  // heroImageUrl = 'http://www.wpclipart.com/cartoon/people/hero/hero_silhoutte_T.png';
  // Public Domain terms of use: http://www.wpclipart.com/terms.html
  final String heroImageUrl = 'assets/images/hero.png';
  // villainImageUrl = 'http://www.clker.com/cliparts/u/s/y/L/x/9/villain-man-hi.png'
  // Public Domain terms of use http://www.clker.com/disclaimer.html
  final String villainImageUrl = 'assets/images/villain.png';

  final String iconUrl = 'assets/images/ng-logo.png';
  bool isActive = false;
  bool isSpecial = true;
  bool isUnchanged = true;

  final Hero nullHero = null;

  void onClickMe(UIEvent event) {
    HtmlElement el = event?.target;
    var evtMsg = event != null ? 'Event target class is ${el.className}.' : '';
    alerter('Click me.$evtMsg');
  }

  void onSave([UIEvent event]) {
    HtmlElement el = event?.target;
    var evtMsg = event != null ? ' Event target is ${el.innerHtml}.' : '';
    alerter('Saved.$evtMsg');
    event?.stopPropagation();
  }

  void onSubmit(form) {/* referenced but not used */}

  Map product = {
  'name': 'frimfram',
  'price': 42
  };

  // updates with fresh set of cloned heroes
  void resetHeroes() {
    heroes = Hero.mockHeroes.map((hero) => new Hero.copy(hero)).toList();
    currentHero = heroes[0];
    heroesWithTrackByCountReset = 0;
  }

  void setUppercaseName(String name) {
    currentHero.name = name.toUpperCase();
  }

  // #docregion setClasses
  Map<String, bool> currentClasses = <String, bool>{};
  void setCurrentClasses() {
    currentClasses = <String, bool>{
      'saveable': canSave,
      'modified': !isUnchanged,
      'special': isSpecial
    };
  }
  // #enddocregion setClasses

  // #docregion setStyles
  Map<String, String> currentStyles = <String, String>{};
  void setCurrentStyles() {
    currentStyles = <String, String>{
      'font-style': canSave ? 'italic' : 'normal',
      'font-weight': !isUnchanged ? 'bold' : 'normal',
      'font-size': isSpecial ? '24px' : '12px'
    };
  }
  // #enddocregion setStyles

  // #docregion trackByHeroes
  int trackByHeroes(int index, Hero hero) => hero.id;
  // #enddocregion trackByHeroes

  // #docregion trackById
  int trackById(int index, dynamic item) => item.id;
  // #enddocregion trackById
}

// helper to track changes to viewChildren
void trackChanges(QueryList<ElementRef> views, void countChange()) {
  List<ElementRef> oldRefs = views.toList();
  views.changes.listen((Iterable<ElementRef> changes) {
    final changedRefs = changes.toList();
    // Is every changed ElemRef the same as old and in the same position
    final isSame = changedRefs.every((e) => oldRefs.contains(e));
    if (!isSame) {
      oldRefs = changedRefs;
      countChange();
    }
  });
}
