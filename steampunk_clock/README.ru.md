:globe_with_meridians:  [english](README.md)	[český](README.cz.md)	**<u>русский</u>**

# Стимпанк часы для конкурса Flutter Clock

Этот проект является **одним из победителей** совместного конкурса, компаний **Google и Lenovo**, под названием «***Flutter Clock***» (с участием **более чем 850** действительных проектов со всего мира). Условием которого была разработка лучшего дизайна часов, при использовании только вспомогательного пакета, предоставленного фирмой Google и бесплатных/свободных инструментов. Больше сведений, на английском языке, вы можете найти на главной странице конкурса: [flutter.dev/clock](https://flutter.dev/clock)

![Визуализация Стимпанк часов](previews/preview.jpg)

Созданный мною дизайн аналоговых часов напоминает Викторианскую эпоху (конец восемнадцатого, начало девятнадцатого веков). Так как это скорее конкурс по дизайну, то тут вы найдёте **большое количество анимации и деталей**, созданных при помощи инструмента [Rive](https://rive.app) (бывший Flare).
> **Примечание:** дизайн является масштабируемым (то-есть вы можете запустить приложение на любом дисплее без потери качества), так как вся графика тут векторная (не растровая), но он создавался скорее для меньших дисплеев (примерно 4-6’, таких же как и размер дисплея умных часов Lenovo).

В приложении есть светлая и тёмная тема, **кукушка, четыре пасхалки** а так же они показывают температуру и погоду, переданные через вспомогательный пакет Flutter Clock Helper. Приложение работает на всех платформах, которые предлагает Flutter, и полностью покрыто тестами. **Видео, показывающие главные особенности этих часов вы можете посмотреть по этой ссылке:**

[![Стимпанк часы для конкурса Flutter Clock](previews/video_preview.jpg)](https://vimeo.com/tsinis/flutterclock)
[Vimeo](https://vimeo.com/tsinis/flutterclock) или [YouTube](https://youtu.be/1cwBYMQwRb8)

---

* Больше информации о коде этого проекта, с моими комментариями и остальные данные, вы найдёте в папке [analog_clock](./analog_clock).
* Больше информации о векторной графике, которая была использована для создания [Rive](https://rive.app) анимации, прошу заглянуть в папку [vector_assets](./vector_assets).

> В каждой из этих двух папок, присутствуют дополнительные видео материалы, по подготовке анимаций или реальному запуску аппликации на реальных устройствах.

* Код вспомогательного  пакета Flutter Clock Helper находится в *нетронутой** папке [flutter_clock_helper](./flutter_clock_helper) в этом репозитории GitHub.

[* *лишь обновил код на null-safety и переместил туда файл ЛИЦЕНЗИИ Google, так как это их код.*](./flutter_clock_helper/LICENSE)