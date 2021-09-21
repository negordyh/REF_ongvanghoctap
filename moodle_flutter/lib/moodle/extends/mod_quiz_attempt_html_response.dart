import 'package:html/dom.dart';
import 'package:moodle_flutter/moodle/authenticate/login_service.dart';

final RegExp _removeHtmlTagRegExp = new RegExp("<[^>]*>");
final RegExp _removeRegExp = new RegExp("\n|\r|&nbsp");

class QuizAnswer {
  final String key;
  final String value;
  final String text;
  final String review;

  QuizAnswer(this.key, this.value, this.text, this.review);

  @override
  String toString() =>
      'QuizAnswer:{key:$key, value:$value, text:$text, review:$review}';
}

class QuestionAttemptHtmlResponse {
  final String question;
  final String typeAnswer;
  final String sequenceCheckName;
  final List<dynamic> answerList;
  final String questionImgHtml;

  QuestionAttemptHtmlResponse.from(final Document dom)
      : this.question = _try(dom, _questionFrom) ?? "",
        this.typeAnswer = _try(dom, _typeAnswerFrom) ?? "",
        this.sequenceCheckName = _try(dom, _sequenceCheckNameFrom) ?? "",
        this.answerList = _try(dom, _answersFrom) ?? List.empty(),
        this.questionImgHtml = _try(dom, _questionImgHtmlFrom) ?? "";

  static dynamic _try(final Document dom, func(final Document dom)) {
    try {
      return func(dom);
    } catch (e) {
      logger.d(e);
      return null;
    }
  }

  static String _questionFrom(Document dom) {
    return dom.getElementsByClassName("qText".toLowerCase()).first.outerHtml;
  }

  static String _typeAnswerFrom(Document dom) {
    return dom
        .getElementsByClassName("answer")
        .first
        .getElementsByTagName("input")
        .last
        .attributes['type'];
  }

  static String _sequenceCheckNameFrom(Document dom) {
    return dom
        .getElementsByClassName("content")
        .first
        .children
        .first
        .getElementsByTagName("input")
        .first
        .attributes["name"];
  }

  static List<dynamic> _answersFrom(Document dom) {
    List<Element> answerElements =
        dom.getElementsByClassName("answer").first.children;
    try {
      return answerElements
          .map((e) => QuizAnswer(
              _keyFrom(e), _valueFrom(e), _textDisplayFrom(e), _reviewFrom(e)))
          .toList();
    } catch (e) {
      logger.e('Parse Answers From Error: $e');
      return [dom.getElementsByClassName("answer").first.outerHtml];
    }
  }

  static String _keyFrom(Element element) {
    return element.getElementsByTagName("input").last.attributes['name'];
  }

  static String _valueFrom(Element element) {
    return element.getElementsByTagName("input").last.attributes['value'];
  }

  static String _textDisplayFrom(Element element) {
    String labelId = element
        .getElementsByTagName("input")
        .last
        .attributes['aria-labelledby'];
    return element.children
        .where((element) => element.attributes['id'] == labelId)
        .last
        .outerHtml
        .replaceAll(_removeHtmlTagRegExp, '');
  }

  static String _reviewFrom(Element element) {
    List<Element> reviewElementList = element.getElementsByTagName("i");
    return reviewElementList.isNotEmpty
        ? reviewElementList.last.attributes['title']
        : null;
  }

  static String _questionImgHtmlFrom(Document dom) {
    return dom
        .getElementsByClassName("content")
        .first
        .getElementsByTagName("img")
        .first
        .outerHtml;
  }
}
