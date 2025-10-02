import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class CarouselControllerModel extends ChangeNotifier {
  final CarouselController controller = CarouselController();
  int currentIndex = 0;
  int itemCount = 0;

  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  bool get canScrollPrev => currentIndex > 0;
  bool get canScrollNext => currentIndex < itemCount - 1;

  void scrollPrev() {
    if (canScrollPrev) controller.previousPage();
  }

  void scrollNext() {
    if (canScrollNext) controller.nextPage();
  }
}

class AppCarousel extends StatefulWidget {
  final List<Widget> items;
  final Axis orientation;
  final double height;

  const AppCarousel({
    Key? key,
    required this.items,
    this.orientation = Axis.horizontal,
    this.height = 200,
  }) : super(key: key);

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  final model = CarouselControllerModel();

  @override
  void initState() {
    super.initState();
    model.itemCount = widget.items.length;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CarouselControllerModel>.value(
      value: model,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            items: widget.items,
            carouselController: model.controller,
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1.0,
              scrollDirection: widget.orientation,
              onPageChanged: (index, reason) => model.setIndex(index),
            ),
          ),
          const Positioned(left: 8, child: CarouselPrevious()),
          const Positioned(right: 8, child: CarouselNext()),
        ],
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final Widget child;

  const CarouselItem({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 4.0), child: child);
  }
}

class CarouselPrevious extends StatelessWidget {
  const CarouselPrevious({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CarouselControllerModel>();
    return IconButton(
      onPressed: model.canScrollPrev ? model.scrollPrev : null,
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
    );
  }
}

class CarouselNext extends StatelessWidget {
  const CarouselNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CarouselControllerModel>();
    return IconButton(
      onPressed: model.canScrollNext ? model.scrollNext : null,
      icon: const Icon(Icons.arrow_forward_ios),
      color: Colors.black,
    );
  }
}
}
  }
}
      color: Colors.black,
    );
  }
}
      icon: const Icon(Icons.arrow_forward_ios),
      color: Colors.black,
    );
  }
}
```
    );
  }
}
```
