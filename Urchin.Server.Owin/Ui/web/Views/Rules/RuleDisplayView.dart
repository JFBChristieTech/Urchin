import 'dart:html';

import '../../MVVM/View.dart';
import '../../MVVM/BoundLabel.dart';
import '../../MVVM/BoundList.dart';
import '../../MVVM/BoundRepeater.dart';

import '../../Html/JsonHighlighter.dart';

import '../../Models/RuleModel.dart';
import '../../Models/VariableModel.dart';

import '../../ViewModels/RuleViewModel.dart';

// import '../../Views/Rules/VariableNameVieww.dart';


class RuleDisplayView extends View
{
	BoundLabel<String> _ruleName;
	BoundLabel<String> _machine;
	BoundLabel<String> _environment;
	BoundLabel<String> _instance;
	BoundLabel<String> _application;
	// BoundRepeater<VariableeModel, VariableViewModel, VariableNameView> _variablesBinding;

	RuleDisplayView([RuleViewModel viewModel])
	{
		_ruleName = new BoundLabel<String>(
			addHeading(2, 'Rule Details'), 
			formatMethod: (s) => s + ' Rule');

		addInlineText('Applies to');

		_instance = new BoundLabel<String>(addSpan(), 
			formatMethod: (s)
			{
				if (s == null || s.length == 0)
					return ' all instances';
				return ' the ' + s + ' instance';
			});

		_application = new BoundLabel<String>(addSpan(), 
			formatMethod: (s)
			{
				if (s == null || s.length == 0)
					return ' of all applications';
				return ' of the ' + s + ' application';
			});

		_machine = new BoundLabel<String>(addSpan(), 
			formatMethod: (s)
			{
				if (s == null || s.length == 0)
					return ' running on any computer';
				return ' running on ' + s;
			});

		_environment = new BoundLabel<String>(addSpan(), 
			formatMethod: (s)
			{
				if (s == null || s.length == 0)
					return ' in any environment';
				return ' in the ' + s + ' environment';
			});

		addHeading(3, 'Variables');

		// _variablesBinding = new BoundRepeater<VariableeModel, VariableViewModel, VariableNameVieww>(
		// 	(vm) => new VariableListElementView(vm), 
		// 	addContainer(), allowAdd: false, allowRemove: false);

		this.viewModel = viewModel;
	}
  
	RuleViewModel _viewModel;
	RuleViewModel get viewModel => _viewModel;

	void set viewModel(RuleViewModel value)
	{
		_viewModel = value;
		if (value == null)
		{
			_ruleName.binding = null;
			_machine.binding = null;
			_environment.binding = null;
			_instance.binding = null;
			_application.binding = null;
		}
		else
		{
			_ruleName.binding = value.name;
			_machine.binding = value.machine;
			_environment.binding = value.environment;
			_instance.binding = value.instance;
			_application.binding = value.application;
			// _rulesBinding.binding = value.variables;
		}
	}
}
