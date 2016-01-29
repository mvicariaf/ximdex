<?php
$I = new AcceptanceTester($scenario);
$I->wantTo('ensure that web installer works');
if(file_exists('conf/_STATUSFILE')){
    $I->deleteFile('conf/_STATUSFILE');
}
$I->amOnPage('/');
$I->see('Ximdex CMS\'s web installer');
$I->see('Check configuration', 'button');
$I->click('Check configuration');
$I->wait(2);
//$I->waitForText('Start installation', 5, 'button');
$I->see('Start installation', 'button');
$I->click('Start installation');
$I->wait(3);
$I->see('Installing Database');
$I->fillField('host', 'localhost');
$I->fillField('port', '3306');
$I->fillField('root_user', 'root');
$I->fillField('root_pass', 'ximdex');
$I->fillField('name', 'ximdex');
$I->see('Create Database', 'button');
$I->click('Create Database');
$I->wait(2);
$overwrite_message = $I->grabTextFrom('p.warning');
echo $overwrite_message;
if($overwrite_message == "ximdex database already exists. Overwrite it?"){
    $I->click('Overwrite database');
}
$I->wait(10);
$I->see('Installing Database');
$I->see('Add user', 'button');
$I->fillField('user', 'ximdex');
$I->fillField('pass', 'ximdex');
$I->click('Add user');
$I->wait(2);
$I->see('Settings');
$I->see('Save settings','button');
$I->fillField('pass', 'ximdex');
$I->click('Save settings');
$I->wait(3);
$I->see('Installing Ximdex CMS\'s default modules');
$I->see('Xtags');
$I->see('Xtour');
$I->see('Xnews');
$I->see('Xpublish');
$I->see('Xowl');
$I->see('Install modules','button');
$I->click('Install modules');
$I->wait(30);
$I->see('Xowl configuration (optional)');
$I->see('Continue','button');
$I->click('Continue');
$I->wait(4);
$I->see('Installation finished!');
$I->see('Get started', 'button');
$I->click('Get started');
$I->wait(5);
$I->see('User');
$I->see('Password');
$I->see('Sign in');
$I->fillField('user', 'ximdex');
$I->fillField('password', 'ximdex');
$I->click('Sign in');
$I->wait(3);
$I->see('Welcome to Ximdex CMS');