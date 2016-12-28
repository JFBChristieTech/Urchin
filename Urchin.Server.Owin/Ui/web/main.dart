import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'ViewModels/DataViewModel.dart';
import 'ViewModels/EnvironmentViewModel.dart';
import 'ViewModels/VersionViewModel.dart';
import 'ViewModels/RuleViewModel.dart';

import 'Events/AppEvents.dart';

import 'Views/Environment/EnvironmentListView.dart';
import 'Views/Environment/EnvironmentEditView.dart';
import 'Views/Environment/EnvironmentDisplayView.dart';

import 'Views/Versions/VersionListView.dart';
import 'Views/Versions/VersionEditView.dart';
import 'Views/Versions/VersionDisplayView.dart';

import 'Views/Navigation/ToolBarView.dart';
import 'Views/Navigation/LogonView.dart';

import 'Views/Rules/RuleDisplayView.dart';

Element _leftDiv;
Element _centreDiv;
Element _rightDiv;
Element _userDiv;
Element _toolBarDiv;

DataViewModel _dataViewModel;
ToolBarView _toolBarView;
LogonView _logonView;

main()
{ 
	_bindHtml();
	_initialView();
	_attachEvents();
}

/*************************************************************************/

void _bindHtml()
{
	_leftDiv = querySelector('#leftDiv');
	_centreDiv = querySelector('#centreDiv');
	_rightDiv = querySelector('#rightDiv');
	_userDiv = querySelector('#userDiv');
	_toolBarDiv = querySelector('#toolBarDiv');
}

/*************************************************************************/

void _initialView()
{
	_dataViewModel = new DataViewModel();

	_toolBarView = new ToolBarView();
	_toolBarView.displayIn(_toolBarDiv);

	_logonView = new LogonView(_dataViewModel.user);
	_logonView.displayIn(_userDiv);

	_displayEnvironmentList(_leftDiv);
}

/*************************************************************************/

void _attachEvents()
{
	AppEvents.tabChanged.listen(_tabChanged);
	AppEvents.environmentSelected.listen(_environmentSelected);
	AppEvents.versionSelected.listen(_versionSelected);
	AppEvents.ruleSelected.listen(_ruleSelected);
}

void _tabChanged(TabChangedEvent e)
{
	_centreDiv.children.clear();

	if (e.tabName == 'Rules') _displayRuleList(_leftDiv);
	else if (e.tabName == 'Environments') _displayEnvironmentList(_leftDiv);
	else if (e.tabName == 'Versions') _displayVersionList(_leftDiv);
}

String _currentView;

void _environmentSelected(EnvironmentSelectedEvent e)
{
	if (_currentView == 'Environments')
		_displayEnvironmentEdit(e.environment, _centreDiv);
	else 
		_displayEnvironmentDisplay(e.environment, _rightDiv);
}

void _versionSelected(VersionSelectedEvent e)
{
	if (_currentView == 'Versions')
		_displayVersionEdit(e.version, _centreDiv);
	else 
		_displayVersionDisplay(e.version, _rightDiv);
}

void _ruleSelected(RuleSelectedEvent e)
{
	if (_currentView == 'Rules')
		_displayRuleEdit(e.rule, _centreDiv);
	else 
		_displayRuleDisplay(e.rule, _rightDiv);
}

/*************************************************************************/

EnvironmentListView _environmentListView;

void _displayEnvironmentList(Element panel)
{
	_currentView = 'Environments';

	if (_environmentListView == null)
		_environmentListView = new EnvironmentListView(_dataViewModel.environmentList);

	_environmentListView.displayIn(panel);
}

EnvironmentEditView _environmentEditView;

void _displayEnvironmentEdit(EnvironmentViewModel environment, Element panel)
{
	if (_environmentEditView == null)
		_environmentEditView = new EnvironmentEditView(environment);
	else
		_environmentEditView.viewModel = environment;

	_environmentEditView.displayIn(panel);
}

EnvironmentDisplayView _environmentDisplayView;

void _displayEnvironmentDisplay(EnvironmentViewModel environment, Element panel)
{
	if (_environmentDisplayView == null)
		_environmentDisplayView = new EnvironmentDisplayView(environment);
	else
		_environmentDisplayView.viewModel = environment;

	_environmentDisplayView.displayIn(panel);
}

/*************************************************************************/

void _displayRuleList(Element panel)
{
	_currentView = 'Rules';
}

void _displayRuleEdit(RuleViewModel rule, Element panel)
{
	_displayRuleDisplay(rule, panel);
}

RuleDisplayView _ruleDisplayView;

void _displayRuleDisplay(RuleViewModel rule, Element panel)
{
	if (_ruleDisplayView == null)
		_ruleDisplayView = new RuleDisplayView(rule);
	else
		_ruleDisplayView.viewModel = rule;

	_ruleDisplayView.displayIn(panel);
}

/*************************************************************************/

VersionListView _versionListView;

void _displayVersionList(Element panel)
{
	_currentView = 'Versions';

	if (_versionListView == null)
		_versionListView = new VersionListView(_dataViewModel.versionList);

	_versionListView.displayIn(panel);
}

VersionEditView _versionEditView;

void _displayVersionEdit(VersionViewModel version, Element panel)
{
	_dataViewModel.versionList.ensureRules(version)
		.then((Null n)
			{
				if (_versionEditView == null)
					_versionEditView = new VersionEditView(version);
				else
					_versionEditView.viewModel = version;

				_versionEditView.environmentListBinding = _dataViewModel.environmentList.environments;
				_versionEditView.displayIn(panel);
			});
}

VersionDisplayView _versionDisplayView;

void _displayVersionDisplay(VersionViewModel version, Element panel)
{
	_dataViewModel.versionList.ensureRules(version)
		.then((Null n)
			{
				if (_versionDisplayView == null)
					_versionDisplayView = new VersionDisplayView(version);
				else
					_versionDisplayView.viewModel = version;

				_versionDisplayView.environmentListBinding = _dataViewModel.environmentList.environments;
				_versionDisplayView.displayIn(panel);
			});
}
