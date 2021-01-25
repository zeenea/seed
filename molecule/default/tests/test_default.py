import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_python(host):
    if host.system_info.distribution in ["ubuntu"]:
        assert host.package("python3").is_installed

    if host.system_info.distribution in ["debian","centos"]:
        assert host.package("python").is_installed


def test_ansible_package_is_installed(host):
    pip_packages = host.pip_package.get_packages()
    assert 'ansible' in pip_packages


def test_ansible_is_in_default_path(host):
    ansible_path = host.check_output('which ansible')
    ansible_dir = host.check_output('dirname '+ansible_path)
    assert ansible_dir in host.check_output('bash -c "echo $PATH"')


def test_system_is_up_to_date(host):

    if host.system_info.distribution in ["debian", "ubuntu"]:
        apt_ok = '0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.'
        assert apt_ok in host.check_output('apt-get --dry-run upgrade')

    if host.system_info.distribution in ["centos"]:
        assert host.run('yum check-update').rc == 0
