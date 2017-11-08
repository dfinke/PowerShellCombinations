class Permutation
{
    hidden [int[]] $data
    hidden [int] $order

    Permutation([int]$n)   
    {
        $this.data = New-Object int[] $n

        for ($i = 0; $i -lt $n; ++$i) {
            $this.data[$i] = $i
        }

        $this.order = $n
    }

    Permutation([int[]]$a)
    {
        $this.data = New-Object int[] $a.Count
        for ($i = 0; $i -lt $a.count ; ++$i)
        { 
            $this.data[$i] = $a[$i]
        }

        $this.order = $a.Count
    }

    [Permutation] Successor() {
        [Permutation]$result = [Permutation]::new($this.order)
    
        [int]$left=0
        [int]$right=0
          
        for ($k = 0; $k -lt $result.order; ++$k)
        {
            $result.data[$k] = $this.data[$k]
        }
          
        $left = $result.order - 2; 
    
        while (($result.data[$left] -gt $result.data[$left+1]) -And ($left -ge 1)) {
            --$left
        }

        if (($left -eq 0) -And ($this.data[$left] -gt $this.data[$left+1])) {return $null}
    
        $right = $result.order - 1
        while ($result.data[$left] -gt $result.data[$right]) {
            --$right
        }
          
        [int]$temp = $result.data[$left]
        $result.data[$left] = $result.data[$right]
        $result.data[$right] = $temp
            
        [int]$i = $left + 1
        [int]$j = $result.order - 1
    
        while ($i -lt $j) {
            $temp = $result.data[$i]
            $result.data[$i++] = $result.data[$j]
            $result.data[$j--] = $temp
        }
    
        return $result
    }

    static [object] Factorial([int]$n)
    {
        $answer = 1
        for ($i = 1; $i -le $n; ++$i)
        {
            $answer *= $i
        }
        
        return $answer
    }

    
    [string[]] ApplyTo([string[]] $sa)
    {
        if ($sa.Length -ne $this.order) { throw "Bad array size in ApplyTo()" }
    
        [string[]]$result = New-Object string[] $this.order
    
        for ($i = 0; $i -lt $result.Length; ++$i) {
            $result[$i] = $sa[$this.data[$i]]
        }
    
        return $result
    }

    [string]ToString() { return "% "+ $this.data + " %" }    
}

function Get-Permutation {
<#
.EXAMPLE 
#
$people = echo Adam John Jane
Get-Permutation $people
#>
    [OutputType("Object[]")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $target
    )

    $p=[Permutation]::new($target.Count)

    while ($p) {
        "$($p.ApplyTo($target))"
        $p=$p.Successor()
    }
}

Export-ModuleMember -Function "Get-Permutation"
