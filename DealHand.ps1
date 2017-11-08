$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptBody = "using module $here\Combination.psm1"
$script = [ScriptBlock]::Create($scriptBody)
. $script

$possibilities = [Combination]::Choose(52,5)
$c = [Combination]::new(52,5)

$deck = $(
    echo As Ks Qs Js Ts 9s 8s 7s 6s 5s 4s 3s 2s
    echo Ac Kc Qc Jc Tc 9c 8c 7c 6c 5c 4c 3c 2c
    echo Ad Kd Qd Jd Td 9d 8d 7d 6d 5d 4d 3d 2d
    echo Ah Kh Qh Jh Th 9h 8h 7h 6h 5h 4h 3h 2h
)

"$($c.Element((Get-Random $possibilities)).ApplyTo($deck))"
